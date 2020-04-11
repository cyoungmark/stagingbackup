({

    handleEventInit : function(component, event, helper) {

        helper.handleEventInitHelper(component, event, helper);

    },

    handleEventChangeIsApprover : function(component, event, helper) {

        //helper.handleEventChangeIsApproverHelper(component, event, helper);

    },

    handleApprove : function(component, event, helper) {

        component.set("v.approvalStatus", 'Approve');

    },

    handleReject : function(component, event, helper) {

        component.set("v.approvalStatus", 'Reject');

    },

    handleSubmit : function(component, event, helper) {

        let approvalStatus = component.get("v.approvalStatus");

        if(approvalStatus == 'Approve') {

            component.find("requestEdit").submit();

        }

        helper.utilSubmitApproval(component, event, helper, approvalStatus);
        component.set("v.approvalStatus", 'Not Set');

    },

    handleCancel : function(component, event, helper) {

        component.set("v.approvalStatus", 'Not Set');

    },
    
    confirmDateChange: function(component, event, helper) {
        component.set("v.confirmedDate", 'Set');
    },
    
    confirmTimeChange: function(component, event, helper) {
        component.set("v.confirmedTime", 'Set');
    }

});