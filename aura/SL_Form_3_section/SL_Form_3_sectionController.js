({
	doInit : function(component, event, helper) {

        var sObjectName = helper.getSObjectName(component);
        var recId = helper.getRecordId(component);
        var fieldset = component.get("v.fieldset");
		
        // Added this 2 lines as per TWG-154 task...
        component.set("v.sObj", {});
        component.set("v.sObjCloned", {});
        
        var action = component.get("c.describeFieldSet");
        action.setParams({
            objType : sObjectName,
            fieldSetName : fieldset
        });

        action.setCallback(this, function(response) {
            
            var returnObj;
            var fieldAPI = [];
            if (response.getState() === "SUCCESS") {
            	console.log('---response.getReturnValue()---'+response.getReturnValue());
                returnObj = JSON.parse(response.getReturnValue());
                if(returnObj != null && returnObj.fieldApiNames != null && returnObj.mapOfFieldApiToFieldsInfo != null) {
                    fieldAPI = returnObj.fieldApiNames;
                    component.set("v.fieldInfo", returnObj.mapOfFieldApiToFieldsInfo);
                    component.set("v.fieldAPI", fieldAPI);
                    component.set("v.fieldType", returnObj.mapOfFieldApiToFieldsInfo.type);
                    console.log('---fieldAPI---'+fieldAPI);
                    action = component.get("c.getCurrentRecord");
                    action.setParams({
                        sObj : sObjectName,
                        fieldNames : fieldAPI.join(),
                        recordId : recId
                    });
                    action.setCallback(this, function(response) {
                        if (response.getState() === "SUCCESS") {
                            var sObj = response.getReturnValue();
                            component.set("v.sObj", sObj);
                            component.set("v.sObjCloned", JSON.parse(JSON.stringify(sObj)));
                        }
                    });
                    $A.enqueueAction(action);
                            
                }
            }

        });
        $A.enqueueAction(action);
	},
    editFieldHandle : function(component, event, helper) {
        var isFieldEdited = event.getParam("isFieldEdited");
        if(isFieldEdited) {
            component.set("v.isEdit", true);
        }
    },
    handleCancel : function(component, event, helper) {
        helper.resetData(component);
    },
    handleSave : function(component, event, helper) {
        var sObjectName = helper.getSObjectName(component);
        var recordToUpdate = [component.get("v.sObj")];
        var action = component.get("c.updateRecord");
        action.setParams({
            sObj : sObjectName,
            jsonObjArr : JSON.stringify(recordToUpdate)
        });
        action.setCallback(this, function(response) {
            var resultsToast = $A.get("e.force:showToast");
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                var objToast = {
                    "message" : "Record updated successfully",
                    "type" : "success"
                };
                if(res === 'success'){
                    component.set("v.isEdit", false);
                    var sObjCloned = JSON.parse(JSON.stringify(recordToUpdate[0]))
                    component.set("v.sObjCloned", sObjCloned);
                    helper.resetData(component);
                }else{
                    objToast['message'] = JSON.parse(res)[0].message;
                    objToast["type"] = "error";
                    objToast["mode"] = "sticky";
                }
                resultsToast.setParams(objToast);
                resultsToast.fire();
                $A.get('e.force:refreshView').fire();
                
            }
            else{
                helper.resetData(component);
                resultsToast.setParams({
                    "message" : "Something went wrong please try again.",
                    "type"    : "error"
                });
                resultsToast.fire();
            }
        });
        $A.enqueueAction(action);
    },

    updateDependentPicklist : function(component, event, helper) {
        var cntrFieldName = event.getParam("cntrFieldName");
        var cntrFieldValue = event.getParam("cntrFieldValue");
        
        var mapDependentPicklistInfo = component.get('v.mapDependentPicklistInfo');
        
        if(mapDependentPicklistInfo.hasOwnProperty(cntrFieldName)) {
            var lstDependentPicklist = mapDependentPicklistInfo[cntrFieldName];
            
            for(var i = 0; i < lstDependentPicklist.length; i++) {
                var objDependentPicklistWrapper = lstDependentPicklist[i];
                var fieldMap = component.get('v.mapFieldInfo');

                var fieldInfo = fieldMap[objDependentPicklistWrapper.dependentFieldName];
                
                if(cntrFieldValue) {
                    var picklistValuesMap = objDependentPicklistWrapper.mapCntrValueListDependentValues;
                    
                    fieldInfo.pickListVals = picklistValuesMap[cntrFieldValue];

                    if(fieldInfo.pickListVals[0].value)
                        fieldInfo.disablePicklist = false;
                    else
                        fieldInfo.disablePicklist = true;
                } else {
                    fieldInfo.disablePicklist = true;
                }
                
                component.set('v.mapFieldInfo', fieldMap);
                var fieldApiNames = component.get("v.fieldApiNames");
                component.set("v.fieldApiNames", fieldApiNames);
            }
        }
    }
})