({
	doInit : function(component, event, helper) {
        var record = component.get("v.record");
		var rows = component.get("v.rows")[0];
        var col = component.get("v.col");
        var row = rows[col];
        var fieldVal = component.get("v.value");
        var fieldAPI  = component.get("v.fieldAPI");
        if(row){
            function getRecordValue(value,fieldName) {
                    
                var lstFields = fieldName.split('.');
                
                var recordValue = value[lstFields[0]]; 
                
                if(lstFields[1] && recordValue){

                    lstFields.splice(0,1);
                    var newFieldName = lstFields.join('.');
                    return getRecordValue(recordValue,newFieldName);
                }
                return recordValue;
            }
        }        
        if(row){
            component.set('v.label', row.label);
            component.set('v.type', row.type);
            component.set('v.editable', row.editable);
            component.set('v.HelpText', row.helpText);
            component.set('v.value', record[col]);
        }
       if(component.get("v.type") === 'PICKLIST' || component.get("v.type") === 'MULTIPICKLIST') {
            helper.fetchPickListVal(component, col, record);
       }
       if(component.get("v.type") === 'REFERENCE') {

                if(fieldVal && (fieldVal.length == 15 || fieldVal.length == 18)){
                    if(fieldAPI.indexOf('__c') > -1 ){
                        var fieldReferenceId = getRecordValue(sobjectRc, fieldAPI.replace("__c","__r.Id"));

                        var test = getRecordValue(sobjectRc, fieldAPI.replace("__c","__r.Name"));

                        component.set("v.fieldVal", test);
                        component.set('v.parentId', fieldReferenceId);
                    }else if(fieldAPI.indexOf('Id')){
                        var fieldReferenceId = fieldVal;
                        var test = getRecordValue(sobjectRc, fieldAPI.replace("Id",".Name"));


                        component.set("v.fieldVal", test);
                        component.set('v.parentId', fieldReferenceId);
                    }
                }
                console.log('-*-*-*-*-*-*-*-*-*-*-*-');
           		console.log(fieldReferenceId);
                if(row.editable) {
                    if (fieldReferenceId!=null)
                    {
                    $A.createComponent(
                        "c:cmp_SL_DynamicLookUp",
                        {   
                            isDisplayCreateNew : false,
                            selRecId : component.get("v.parentId"),
                            selRecName : component.get("v.fieldVal"),
                            isError : false,
                            isFilter : false,
                            sObjectAPIName:'',
                            pluralLabel:''
                        },
                        function(newButton, status, errorMessage){
                            if (status === "SUCCESS") {
                                
                                var targetCmp = component.find('lookupField');
                                var body = targetCmp.get("v.body");
                                body.push(newButton);
                                targetCmp.set("v.body", body);
                            }
                            else if (status === "INCOMPLETE") {
                                console.log("No response from server or client is offline.")
                                // Show offline error
                            }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                                // Show error message
                            }
                        }
                    );
                }
       		}
            }
	},
    handleClick : function(component, event, helper) {
        var updateEvent = component.getEvent("SL_FL_evt_FieldEdited");
        updateEvent.setParams({
            "isFieldEdited" : true
        });
        updateEvent.fire();
    },
    onSelectChange : function(component, event, helper){
        var selectCmp = component.find("picklist");
        component.set("v.value", selectCmp.get("v.value"));
        var record = component.get("v.record");
        var fieldName = component.get("v.col");
        record[fieldName] = selectCmp.get("v.value");
    },
    onMultiSelectChange: function(component, event, helper){
        var selectCmp = component.find("multipicklist");
        component.set("v.value", selectCmp.get("v.value"));
        var record = component.get("v.record");
        var fieldName = component.get("v.col");
        record[fieldName] = selectCmp.get("v.value");
    },
    updateVal : function(component, event, helper){
        var updatedVal = event.getSource().get("v.value");
        if(updatedVal !== undefined){
            var record = component.get("v.record");
			var fieldName = component.get("v.col");
            record[fieldName] = updatedVal;
        }
    }
})