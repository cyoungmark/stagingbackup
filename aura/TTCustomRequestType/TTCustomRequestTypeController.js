({
    doInit: function (component, event, helper) {
        var options = [];
        var action = component.get("c.getOptions");
        action.setParams({ TTId: component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {   
                var resultArray = response.getReturnValue();
                
                if (resultArray[0]==null){resultArray[0]='';}
                //console.log(resultArray);
                var options = [];
                
                if (resultArray[0]!=''){
                    var res = resultArray[0].split("|");
                    for (var i=0;i<res.length;i++){
                        var sel = false;
                        if (res[i]==resultArray[1]){
                            sel = true;
                        }
                        options.push({ val: res[i], selected: sel});
                    }
                }
                component.set("v.options", options);
                component.set("v.selectedOption", resultArray[1]);
                
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },
    onChangeOption : function (component, event) {

            var action = component.get("c.setOptions");
        
            action.setParams({ TTId: component.get("v.recordId"), options: component.get("v.selectedOption")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(response.getReturnValue());
                if (!component.isValid() || state != 'SUCCESS') {  
                    console.log(response.getError()[0]);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                         title: 'Error',
                         type: 'error',
                         message: response.getError()[0].message,
                        messageTemplate: response.getError()[0],
                        key: 'info_alt',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                //console.log(state);
            });
            $A.enqueueAction(action); 
    }
})