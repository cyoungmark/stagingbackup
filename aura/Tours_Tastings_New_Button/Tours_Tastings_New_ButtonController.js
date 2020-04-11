/**
 * Created by Dmytro Minko on 2019-07-03.
 */

({
    handleEventInit : function(component, event, helper) {

        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Attention",
            "message": "To create a Tours and Tastings Request please select an Account first and click on the button labeled Tours and Tastings Request at the top right hand corner of the screen.",
            "type": "warning",
            "mode": "sticky"
        });
        resultsToast.fire();

        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Account"
        });
        homeEvent.fire();
    },
});