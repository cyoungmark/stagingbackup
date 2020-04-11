/**
 * Created by cyoungmark on 2019-07-24.
 */

@IsTest
private class ToursTastingsFormApprovalControllerTest {

    @testSetup
    private static void generateData() {

        // TODO: Create Winery Account
        Account wineryAccount = new Account(

                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Winery_Account').getRecordTypeId(),
                Name = 'Test Winery',
                Tours_Tastings_Accepted__c = true,
                Private_Tours__c = true

        );

        insert wineryAccount;

        // TODO: Create Retailer Account
        Account retailerAccount = new Account(

                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retailer_Account').getRecordTypeId(),
                Name = 'Test Retailer'

        );

        insert retailerAccount;

        // TODO: Create Primary Contact
        Contact primaryContact = new Contact(

                AccountId = retailerAccount.Id,
                FirstName = 'Test',
                LastName = 'Guest',
                Email = 'test@test.com',
                MobilePhone = '312-588-2300'

        );

        // TODO: Create Tour and Tastings Form

        Tours_and_Tastings__c theForm = new Tours_and_Tastings__c(

                Request_Type__c = 'Consumer',
                Primary_Guest_Name__c = primaryContact.Id,
                Number_of_Guests__c = 1,
                Level_of_Wine_Knowledge__c = 'High'
            	

        );

        insert theForm;
        
        Tours_and_Tastings__c theForm2 = new Tours_and_Tastings__c(

                Request_Type__c = 'Consumer',
                Primary_Guest_Name__c = primaryContact.Id,
                Number_of_Guests__c = 1,
                Level_of_Wine_Knowledge__c = 'Novice'
            	

        );

		insert theForm2;
        // TODO: Create Tour and Tastings Request

        Tour_and_Tasting_Request__c theRequestForApproval = new Tour_and_Tasting_Request__c(

                Tour_and_Tasting__c = theForm.Id,
                Winery__c = wineryAccount.Id,
                Earliest_Date_of_Visit__c = Date.Today() + 14,
                Earliest_Start_Time__c = '10:00 AM PDT',
                Latest_Date_of_Visit__c = Date.Today() + 21,
                Latest_Start_Time__c = '11:00 AM PDT',
                Request_Type__c = 'Tour',
                Request_Type_text__c = 'Tour',
            	Confirmed_Date_Of_Visit__c = Date.today() + 14,
            	Confirmed_Time_Of_Visit__c = '10:00 AM PDT',
            	Itinerary_Recipient_Email__c = 'Test@test.com'

        );

        insert theRequestForApproval;

        Tour_and_Tasting_Request__c theRequestWithoutApproval = new Tour_and_Tasting_Request__c(

                Tour_and_Tasting__c = theForm.Id,
                Winery__c = wineryAccount.Id,
                Earliest_Date_of_Visit__c = Date.Today() + 14,
                Earliest_Start_Time__c = '10:00 AM PDT',
                Latest_Date_of_Visit__c = Date.Today() + 21,
                Latest_Start_Time__c = '11:00 AM PDT',
                Request_Type__c = 'Tasting',
                Request_Type_text__c = 'Tasting',
            	Confirmed_Date_Of_Visit__c = Date.today() + 14,
            	Confirmed_Time_Of_Visit__c = '10:00 AM PDT',
            	Itinerary_Recipient_Email__c = 'Test@test.com'

        );

        insert theRequestWithoutApproval;

        // TODO: Submit approval request

        Approval.ProcessSubmitRequest theApproval = new Approval.ProcessSubmitRequest();

        theApproval.setComments('Please approve this request.');
        theApproval.setObjectId(theForm.id);

        Approval.ProcessResult theApprovalResult = Approval.process(theApproval);

    }

    @isTest
    private static void testGetProcessInstance() {

        // Retrieve the Request so that you can use its Id

        Tours_and_Tastings__c theRequestWithApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'High' LIMIT 1];
        Tours_and_Tastings__c theRequestWithoutApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'Novice' LIMIT 1];

        Test.StartTest();

        //Happy Path: Approval Request was submitted
        ProcessInstance theProcessInstanceHappyPath = ToursTastingsFormApprovalController.getProcessInstance(theRequestWithApproval.Id);

        //Alternative Path: Approval Request wasn't submitted
        ProcessInstance theProcessInstanceAlternativePath = ToursTastingsFormApprovalController.getProcessInstance(theRequestWithoutApproval.Id);

        Test.StopTest();

        System.AssertEquals('Pending', theProcessInstanceHappyPath.Status, 'Happy path: Process Instance status is wrong!');
        System.AssertEquals(null, theProcessInstanceAlternativePath, 'Alternative path: Process Instance must be null');
    }

    @isTest
    private static void testGetProcessInstanceWorkitem() {

        // Retrieve the Request so that you can use its Id

        Tours_and_Tastings__c theRequestWithApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'High' LIMIT 1];
        Tours_and_Tastings__c theRequestWithoutApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'Novice' LIMIT 1];

        Test.StartTest();

        //Happy Path: Approval Request was submitted
        ProcessInstanceWorkitem theProcessInstanceWorkItemHappyPath = ToursTastingsFormApprovalController.getProcessInstanceWorkitem(theRequestWithApproval.Id);

        //Alternative Path: Approval Request wasn't submitted
        ProcessInstanceWorkitem theProcessInstanceWorkItemAlternativePath = ToursTastingsFormApprovalController.getProcessInstanceWorkitem(theRequestWithoutApproval.Id);

        Test.StopTest();

        System.AssertNotEquals(null, theProcessInstanceWorkItemHappyPath, 'Happy Path: Process Instance Work Item cannot be null');
        System.AssertEquals(null, theProcessInstanceWorkItemAlternativePath, 'Alternative Path: Process Instance Work Item must be null');
    }

    @isTest
    private static void testGetProcessInstanceHistory() {

        // Retrieve the Request so that you can use its Id

        Tours_and_Tastings__c theRequestWithApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'High' LIMIT 1];
        Tours_and_Tastings__c theRequestWithoutApproval = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'Novice' LIMIT 1];

        Test.StartTest();

        //Happy Path: Approval Request was submitted
        ProcessInstanceHistory theProcessInstanceHistoryHappyPath = ToursTastingsFormApprovalController.getLatestHistory(theRequestWithApproval.Id);

        //Alternative Path: Approval Request wasn't submitted
        ProcessInstanceHistory theProcessInstanceHistoryAlternativePath = ToursTastingsFormApprovalController.getLatestHistory(theRequestWithoutApproval.Id);

        Test.StopTest();

        System.AssertNotEquals(null, theProcessInstanceHistoryHappyPath, 'Happy Path: Process Instance History cannot be null');
        System.AssertEquals(null, theProcessInstanceHistoryAlternativePath, 'Alternative Path: Process Instance History must be null');

    }

    @isTest
    private static void testIsApprover() {

        // Retrieve the Request so that you can use its Id

        Tours_and_Tastings__c theRequest = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'High' LIMIT 1];

        Test.StartTest();

        Boolean isApprover = ToursTastingsFormApprovalController.isApprover(theRequest.Id);

        Test.StopTest();

    }

    @isTest
    private static void testRunningUser() {

        Test.StartTest();

        User runningUser = ToursTastingsFormApprovalController.getRunningUser();

        Test.StopTest();

        System.AssertEquals(userInfo.getUserId(), runningUser.Id);

    }

    @isTest
    private static void testSubmitApproval() {

        // Retrieve the Request so that you can use its Id

		Tours_and_Tastings__c theRequest = [SELECT Id FROM Tours_and_Tastings__c WHERE Request_Type__c = 'Consumer' AND Level_of_Wine_Knowledge__c = 'High' LIMIT 1];        

        Test.StartTest();

        Boolean isSuccess = ToursTastingsFormApprovalController.submitApproval(theRequest.Id, 'Approve', 'Test approval comments.');

        Test.StopTest();

        System.Assert(isSuccess);

    }


}