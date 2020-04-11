({

    handleEventInitHelper : function(component, event, helper){

        helper.utilCheckApprovalStatus(component, helper);
        helper.utilQueryProcessInstance(component, helper);
        helper.utilQueryProcessInstanceHistory(component, helper);

    },

    handleEventChangeIsApproverHelper : function(component, event, helper){



    },

    utilQueryProcessInstance : function(component, helper){

        helper.utilCallServer(
            component,
            "c.getProcessInstance",
            function(response) {


                component.set("v.theProcessInstance", response);

            },

            {

                "theRequestId"  :   component.get("v.recordId")

            }

        );

    },

    utilQueryProcessInstanceHistory : function(component, helper){

        helper.utilCallServer(
            component,
            "c.getLatestHistory",
            function(response) {

                console.log(JSON.stringify(response));
                //alert(JSON.stringify(response));

                    component.set("v.theProcessInstanceHistory", response);

            },

            {

                "theRequestId"  :   component.get("v.recordId")

            }

        );

    },

    utilCheckApprovalStatus : function(component, helper) {

        //var studentProfile = component.get("v.studentProfile");

        helper.utilCallServer(
            component,
            "c.isApprover",
            function(response) {

                component.set("v.isApprover", response);

            },

            {

                "theRequestId"  :   component.get("v.recordId")

            }

        );

    },

    utilSubmitApproval : function(component, event, helper, approvalStatus) {

        //var studentProfile = component.get("v.studentProfile");

        helper.utilCallServer(
            component,
            "c.submitApproval",
            function(response) {

                let refreshEvent = $A.get('e.force:refreshView');
                let toastEvent = $A.get("e.force:showToast");
                let title = 'Default';
                let message = 'Default'
                //let approvalStatus = component.get("v.approvalStatus");

                //alert(approvalStatus);
                if(response) {

                    title = 'Submitted'

                    if(approvalStatus == 'Approve') {

                        message = 'This Tour and Tasting Request was successfully approved!';

                    }

                    else if(approvalStatus == 'Reject') {

                        message = 'This Tour and Tasting Request has been rejected.';

                    }

                }

                else {

                    title = 'ERROR'
                    message = 'There was a problem with this Tour and Tasting Request.';

                }

                toastEvent.setParams({

                    "title": title,
                    "message": message

                });

                refreshEvent.fire();
                toastEvent.fire();
                helper.handleEventInitHelper(component, event, helper);

            },

            {

                "theRequestId" : component.get("v.recordId"),
                "approverAction" : component.get("v.approvalStatus"),
                "approverComments" : component.get("v.approvalComments")

            }

        );

    },


    utilCallServer : function(component,method,callback,params,storable) {

        var action = component.get(method);
        if (params) {
            action.setParams(params);
        }
/*
        if (storable) {
            action.setStorable();
        } else {
            action.setStorable({
                "ignoreExisting": "true"
            });

        }
*/
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // pass returned value to callback function
                callback.call(this,response.getReturnValue());
                //var dataLoadSuccessEvent = component.getEvent("dataLoadSuccess");
                //dataLoadSuccessEvent.fire();

            } else if (state === "ERROR") {
                // generic error handler
                //var dataLoadFailEvent = component.getEvent("dataLoadFail");
                //dataLoadFailEvent.fire();

                var errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }



            }


        });

        $A.enqueueAction(action);
    },


});