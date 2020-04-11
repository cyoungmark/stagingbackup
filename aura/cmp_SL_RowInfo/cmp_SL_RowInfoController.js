({
	doInit : function(component, event, helper) {
		var fieldMap = component.get('v.FieldInfoMap');
        
        var fieldApi = component.get('v.fieldApiName');
        var fieldInfo = fieldMap[fieldApi];
        
        var mapDependentPicklistInfo = component.get('v.mapDependentPicklistInfo');
        var isControllingPicklist = false;
        
        if(mapDependentPicklistInfo.hasOwnProperty(fieldApi))
        	isControllingPicklist = true;
        
        if(fieldInfo){
        
            component.set('v.fieldType', fieldInfo.type); 
            component.set('v.fieldLabel', fieldInfo.label); 
            component.set('v.PickListValsNew', fieldInfo.pickListVals);
            component.set('v.sObjectName', fieldInfo.referenceTo);
			component.set('v.disablePicklist', fieldInfo.disablePicklist);
            
            $A.createComponent(
                "c:cmp_SL_RenderFields",
                {	
                    record : component.getReference("v.SobjRecord"),
                    fieldApiName : component.getReference("v.fieldApiName"),
                    fieldType : component.getReference("v.fieldType"),
                    fieldSetLabelVal : component.getReference("v.fieldLabel"),
                    PickListVals : component.getReference("v.PickListValsNew"),
                    sObjectName : component.getReference("v.sObjectName"),
                    isReadOnly : component.getReference("v.isReadOnly"),
                    disablePicklist : component.getReference("v.disablePicklist"),
                    isControllingPicklist : isControllingPicklist
                },
                function(newButton, status, errorMessage){
                    if (status === "SUCCESS") {
                        
                        var targetCmp = component.find('cmpRenderFields');
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
	},
    
    testChange : function(component, event, helper) {
        var fieldMap = component.get('v.FieldInfoMap');
        
        var fieldApi = component.get('v.fieldApiName');
        var fieldInfo = fieldMap[fieldApi];
        
        component.set('v.PickListValsNew', fieldInfo.pickListVals);
        component.set('v.disablePicklist', fieldInfo.disablePicklist);
    }
})