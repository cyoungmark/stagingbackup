({
	doInit: function (component, event, helper) {
        var options = [
        ];
        var action = component.get("c.getOptions");
        action.setParams({ accId: component.get("v.recordId")});
        component.set("v.listOptions", options);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {   
                var resultArray = response.getReturnValue();
                if (resultArray==null){resultArray='';}
                //console.log(resultArray);
                var options = [];
                var options2 = [];
                
                /*
                if (!resultArray.includes('Consumer Request')){
                	options.push({ value: 'Consumer Request', label: 'Consumer Request'});
                }
                if (!resultArray.includes('Distributor of Employee')){
                	options.push({ value: 'Distributor of Employee', label: 'Distributor of Employee'});
                }
                if (!resultArray.includes('Family and VIPs')){
                	options.push({ value: 'Family and VIPs', label: 'Family and VIPs'});
                }
                if (!resultArray.includes('Retailer / Restauranteur')){
                	options.push({ value: 'Retailer / Restauranteur', label: 'Retailer / Restauranteur'});
                }
                */
                
                
                var action2 = component.get("c.getInactiveOptions");
        		action2.setParams({ accId: component.get("v.recordId")});
                action2.setCallback(this, function(response2) {
                var state2 = response2.getState();
                if (component.isValid() && state2 == 'SUCCESS') { 
                    var resultArray2 = response2.getReturnValue();
                    console.log(resultArray2);
                    if (resultArray2==null){resultArray2='';}
                    if (resultArray2!=''){
                    	var res2 = resultArray2.split("|");
                        for (var i=0;i<res2.length;i++){
                            console.log(res2[i]);
                           options.push({ value: res2[i], label: res2[i]});
                        }
                    }
                }
                    if (resultArray!=''){
                        var res = resultArray.split("|");
                        for (var i=0;i<res.length;i++){
                            options.push({ value: res[i], label: res[i]});
                            options2.push(res[i]); 
                        }
                    }
                    component.set("v.listOptions", options);
                    component.set("v.defaultOptions", options2);
                });
                 $A.enqueueAction(action2); 
                
               
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action); 
        
		
        var action2 = component.get("c.UserHasAccess");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
            	component.set("v.HasAccess", response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    handleChange: function (component, event) {
        var selectedOptionsList = event.getParam("value");
        console.log(selectedOptionsList);
        //var OldselectedOptionsList = event.getParam("oldValue");
        //console.log(OldselectedOptionsList);
        
        var action = component.get("c.setOptions");
        
        action.setParams({ accId: component.get("v.recordId"), options: selectedOptionsList});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {   
                component.set("v.selectedArray", selectedOptionsList);
            }
        });
        $A.enqueueAction(action); 
        
    }, 
    addRequestType: function (component, event) {
        if (component.get("v.NewReqTypeValue")!=''){
            console.log(component.get("v.NewReqTypeValue"));
            var opt = [];
            opt = component.get("v.defaultOptions");
            opt.push(component.get("v.NewReqTypeValue"));
            
            console.log(opt);
            
            var opt2=[];
            opt2= component.get("v.listOptions");
            opt2.push({ value: component.get("v.NewReqTypeValue"), label: component.get("v.NewReqTypeValue")} );
            
            
            var action = component.get("c.setOptions");
        
            action.setParams({ accId: component.get("v.recordId"), options: opt});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state == 'SUCCESS') {   
                    
                    component.set("v.defaultOptions",opt);
                    component.set("v.listOptions",opt2);
            		component.set("v.NewReqTypeValue",'');
                }
            });
            $A.enqueueAction(action); 
                
        }
    }
})