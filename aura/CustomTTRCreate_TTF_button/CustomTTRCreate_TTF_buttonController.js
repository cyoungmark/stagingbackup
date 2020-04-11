({	
    doInit : function (component, event, helper) {
        component.set("v.newTTR.Tour_and_Tasting__c", component.get("v.recordId"));
    },
   changeWinery: function (component, event, helper) {
	var options = [];
        var action = component.get("c.getOptions");
       console.log(component.get("v.newTTR.Winery__c"));
        action.setParams({ accId: component.get("v.newTTR.Winery__c")[0]});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {   
                var resultArray = response.getReturnValue();
                
                if (resultArray==null){resultArray='';}
                console.log(resultArray);
                var options = [];
                
                if (resultArray!=''){
                    var res = resultArray.split("|");
                    for (var i=0;i<res.length;i++){
                        var sel = false;
                        options.push({ val: res[i]});
                    }
                }
                component.set("v.options", options);
                
            } else {
                console.log('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(action);
   },
    changeCheckbox: function (component, event, helper) {
        var checkbox = component.find("Lunch_Request__c");
        component.set("v.newTTR.Lunch_Request__c", checkbox.get("v.value"));
        checkbox = component.find("First_Visit__c");
        component.set("v.newTTR.First_Visit__c", checkbox.get("v.value"));
        checkbox = component.find("Lodging_Request__c");
        component.set("v.newTTR.Lodging_Request__c", checkbox.get("v.value"));
    },
    saveRecord: function (component, event, helper) {
        console.log(component.get("v.newTTR.Lunch_Request__c"));
        var record = component.get("v.newTTR");
        if(record.Tour_and_Tasting__c==''||record.Winery__c==''||record.Earliest_Date_of_Visit__c==null||record.EarliestStartTime_del__c==''||
           record.Latest_Date_of_Visit__c==null||record.LatestStartTime_del__c==''||record.Request_Type_text__c==''
          ){
             component.find('notifLib').showNotice({
                "variant": "error",
                "header": "Error",
                "message": "Please, complete all required fields.",
                closeCallback: function() {
                    //alert('You closed the alert!');
                }
            });
        } else {
            


            var action = component.get("c.saveRecordContr");
            action.setParams({ TTrec: JSON.stringify(component.get("v.newTTR"))});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state == 'SUCCESS') {   
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": component.get("v.recordId")
                    });
                    navEvt.fire();
                    
                } else {
                    console.log('Failed with state: ' + state);
                    component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Error",
                        "message": response.getError()[0].message,
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    });

                    
                }
            });
            $A.enqueueAction(action);
        }
    },
    saveRecordAndNew: function (component, event, helper) {
        console.log(component.get("v.newTTR.Lunch_Request__c"));
        var record = component.get("v.newTTR");
        if(record.Tour_and_Tasting__c==''||record.Winery__c==''||record.Earliest_Date_of_Visit__c==null||record.EarliestStartTime_del__c==''||
           record.Latest_Date_of_Visit__c==null||record.LatestStartTime_del__c==''||record.Request_Type_text__c==''
          ){
           
            component.find('notifLib').showNotice({
                "variant": "error",
                "header": "Error",
                "message": "Please, complete all required fields.",
                closeCallback: function() {
                    //alert('You closed the alert!');
                }
            });
        } else {
            var action = component.get("c.saveRecordContr");
            action.setParams({ TTrec: JSON.stringify(component.get("v.newTTR"))});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state == 'SUCCESS') { 
                    
                    var ttfId = component.get("v.newTTR.Tour_and_Tasting__c");
                    var winaryId = component.get("v.newTTR.Winery__c");
                    component.set("v.newTTR", component.get("v.newTTREmpty"));
                    component.set("v.newTTR.Tour_and_Tasting__c",ttfId);
                    
                    component.set("v.newTTR.Winery__c",winaryId);
                    
                    //$A.get('e.force:refreshView').fire();
                    
                    component.find('notifLib').showNotice({
                    "variant": "info",
                    "header": "T&T Request successfully saved!",
                    "message": "T&T Request successfully saved!",
                    closeCallback: function() {
                        //alert('You closed the alert!');
                    }
                });
                    
                } else {
                    console.log('Failed with state: ' + state);
                    
                    component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Error",
                        "message": response.getError()[0].message,
                        closeCallback: function() {
                            //alert('You closed the alert!');
                        }
                    });
                    
                }
            });
            $A.enqueueAction(action);
        }
    },
    cancelDialog : function(component, helper) {
		/*var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Tours_and_Tastings__c"
        });
        homeEvt.fire();*/
        //$A.get('e.force:refreshView').fire();
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": component.get("v.recordId")
        });
        navEvt.fire();

    }
})