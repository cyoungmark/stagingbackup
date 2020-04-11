({
    fetchPickListVal: function(component, fieldName, record) {
        var action = component.get("c.getselectOptions");

        action.setParams({
            "fld": fieldName,
            "record": record
        });

        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for(var i=0;i<allValues.length;i++){
                    if (allValues[i].value==component.get('v.value')){
                        component.set('v.PicklistValueLabel', allValues[i].label);
                    }
                }
                component.set('v.picklistOptions', allValues);
            }
        });
        $A.enqueueAction(action);
    },
})