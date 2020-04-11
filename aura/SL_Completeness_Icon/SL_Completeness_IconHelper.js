({
	getPercentFieldMap: function(component){
		component.set("v.isSpinning",true);
		var recordId = component.get("v.recordId");
     	var sObjectAPIName = component.get("v.sObjectAPIName");
    	var fieldSetAPIName = component.get("v.fieldSetAPIName");

        var pfMap = component.get("c.getFieldCompletenessInfo");

        pfMap.setParams({objId: recordId,sObjectAPIName:sObjectAPIName,fieldSetAPIName:fieldSetAPIName});

        pfMap.setCallback(this,function(returnJSON) {
            
        	var returnObj = JSON.parse(returnJSON.getReturnValue());
            
            if(returnObj != null) {
                
                component.set("v.fieldPercent", returnObj.fieldsRatio);
                component.set("v.noOfMissingRequiredFields", returnObj.numberOfRequiredFieldsMissing);
                component.set("v.nullFields", returnObj.nullFields);
            }
            
       		component.set("v.isSpinning",false);
        });
        $A.enqueueAction(pfMap);
	}
	
})