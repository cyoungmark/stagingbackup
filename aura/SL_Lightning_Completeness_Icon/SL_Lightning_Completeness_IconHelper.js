({
	saveRecord : function(component) {
        var updatedRecord = component.get('v.selectedSObject');
        var apiFieldAndFieldInfos = component.get('v.mapFieldInfo');
        var objRec = {};
        var apiFiedNames = [];
        
        for (var property in apiFieldAndFieldInfos){
            if (apiFieldAndFieldInfos.hasOwnProperty(property)) {
                var fieldName = apiFieldAndFieldInfos[property].fieldPath;
                var fieldType = apiFieldAndFieldInfos[property].type;
                
                if(fieldType != 'FORMULA'){
                    
                    apiFiedNames.push(apiFieldAndFieldInfos[property]);
                    objRec[fieldName] = updatedRecord[fieldName];
                }
            }
        }
		
        var action = component.get("c.saveSOjectRecord");
        action.setParams({ 
            strRecId : updatedRecord['Id'],
            strJSONRec : JSON.stringify(objRec),
            strFieldApiInfos : JSON.stringify(apiFiedNames),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnRec = response.getReturnValue();
                
                var resultsToast = $A.get("e.force:showToast");
                var objToast = {"title" : "Update", "message" : returnRec.strMsg};
                
                if(returnRec.isError){
                    // Error Toast..
                    objToast["type"] = "error";
                }else{
                    // Success Toast..
                    objToast["type"] = "success";
                }
                
                // Fire toast msg...
                resultsToast.setParams(objToast);
                resultsToast.fire();
                
                // Refreshing the View...to show updated values...
                //$A.get('e.force:refreshView').fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
				navEvt.setParams({
				  "recordId": updatedRecord['Id'],
				  "slideDevName": "detail"
				});
				navEvt.fire();
                
            }else{
                //error Toast...
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title"   : "Update", 
                    "message" : "Something went wrong please try again.",
                    "type"    : "error" 
                });
                resultsToast.fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})