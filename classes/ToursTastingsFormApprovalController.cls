public inherited sharing class ToursTastingsFormApprovalController {

    @AuraEnabled
    public static Boolean submitApproval(Id theRequestId, String approverAction, String approverComments) {

        Approval.ProcessWorkitemRequest theProcessWorkitemRequest = new Approval.ProcessWorkitemRequest();
        theProcessWorkitemRequest.setComments(approverComments);

        // Approve Request
        theProcessWorkitemRequest.setAction(approverAction);

        theProcessWorkitemRequest.setWorkitemId(getProcessInstanceWorkitem(theRequestId).Id);

        //update theRequest;
        Approval.ProcessResult theResult = Approval.process(theProcessWorkitemRequest);

        return theResult.isSuccess();

    }

    @AuraEnabled
    public static ProcessInstance getProcessInstance(Id theRequestId) {

        List <ProcessInstance> instances = [
                SELECT Id, CompletedDate, ElapsedTimeInDays, ElapsedTimeInHours, ElapsedTimeInMinutes, LastActorId, Status
                FROM ProcessInstance
                WHERE TargetObjectId = :theRequestId
                ORDER BY SystemModstamp DESC
                LIMIT 1
        ];

        return instances.isEmpty() ? null : instances.get(0);
    }

    @AuraEnabled
    public static ProcessInstanceWorkitem getProcessInstanceWorkitem(Id theRequestId) {

        List <ProcessInstanceWorkitem> instanceWorkitems = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :theRequestId];

        return instanceWorkitems.isEmpty() ? null : instanceWorkitems.get(0);
    }

    @AuraEnabled
    public static ProcessInstanceHistory getLatestHistory(Id theRequestId) {

        Tours_and_Tastings__c theRequest = queryTourAndTastingForm(theRequestId);

        ProcessInstanceHistory latestHistory;

        if(!theRequest.ProcessSteps.isEmpty()) {

            latestHistory = theRequest.ProcessSteps[0];

        }

        return latestHistory;
    }
    @AuraEnabled(cacheable=true)
    public static Boolean isRequestsReady(Id theFormId) {
        Boolean returnValue = true;
        Tours_and_Tastings__c tt = [SELECT Id, (SELECT Id, Approval_Status__c FROM Tour_and_Tasting_Requests__r) FROM Tours_and_Tastings__c WHERE Id =: theFormId];
        for (Tour_and_tasting_request__c ttr : tt.Tour_and_Tasting_Requests__r) {
            if (ttr.Approval_Status__c == 'Pending') returnValue = false;
        }
        return returnValue;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isApprover(Id theRequestId) {
        system.debug('requestID: ' + theRequestId);

        Tours_and_Tastings__c theRequest = queryTourAndTastingForm(theRequestId);

        ProcessInstanceHistory theStep;

        if(!theRequest.ProcessSteps.isEmpty()) {
            theStep = theRequest.ProcessSteps[0];
        }

        if(theStep != null) {
            if(theStep.ActorId.getSobjectType().getDescribe().getName() == 'Group') {
                if(queryApproverQueueMembers(queryApproverQueue(theStep.ActorId).Id).containsKey(getRunningUser().Id)) {
                    return true;
                }
            }

            else if(getRunningUser().Id == theStep.ActorId) {
                return true;
            }
        }

        return false;
    }

    @AuraEnabled
    public static User getRunningUser() {

        return getUserInfo(userInfo.getUserId());

    }

    @AuraEnabled
    public static User getUserInfo(Id theUserId) {

        return [
                SELECT Id, FirstName, LastName, Username, Email, UserRole.name, Profile.name
                FROM User
                WHERE Id =: theUserId
        ];

    }

    @AuraEnabled
    public static Tours_and_Tastings__c queryTourAndTastingForm(Id theRequestId) {
        system.debug('requestID: ' + theRequestId);
		Tours_and_Tastings__c tnt = new Tours_and_Tastings__c();
        tnt = [
                SELECT Id,
                (SELECT Id,
                        TargetObjectId,
                        StepStatus,
                        ProcessInstanceId,
                        OriginalActorId,
                        IsPending,
                        Comments,
                        ActorId
                FROM ProcessSteps
                ORDER BY SystemModstamp DESC)
                FROM Tours_and_Tastings__c
                WHERE Id = :theRequestId
        ];
        return tnt;
    }

    @AuraEnabled
    public static Group queryApproverQueue(Id theQueueId) {

        return [
                SELECT Id, Name
                FROM Group
                WHERE Id = :theQueueId
        ];

    }

    @AuraEnabled
    public static Map<Id, User> queryApproverQueueMembers(Id theQueueId) {

        return new Map<Id, User>([
                    SELECT Id, FirstName, LastName, Username, Email, UserRole.name, Profile.name
                    FROM User
                    WHERE Id IN ( SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :theQueueId )
                    AND
                    isActive = true
        ]);
    }
}