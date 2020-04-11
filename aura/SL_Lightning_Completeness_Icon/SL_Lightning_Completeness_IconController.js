({
	doInit: function(component,event,helper){

		component.set("v.cirDeg",(component.get("v.fieldPercent")*360/100).toString());
		
        if(component.get("v.displayCount")) {
            var countFields = component.find("countFields");
			$A.util.removeClass(countFields, "slds-hidden");
        }
        
        if(component.get("v.nullFields").length > 4) {
            component.set("v.displayMoreIcon", true);
            var circle = component.find("circlePercent");
        }
	},

	displayTable: function(component,event,helper){
		var table = component.find("table");
		$A.util.removeClass(table, "slds-hidden");
        
        var more = component.find("moreIcon");
		$A.util.removeClass(more, "slds-hidden");
	},
	hideTable: function(component,event,helper){
		var table = component.find("table");
		$A.util.addClass(table, "slds-hidden");
        
        var more = component.find("moreIcon");
		$A.util.addClass(more, "slds-hidden");
	},
    
    openMissingFieldsModal: function(component, event, helper) {
        component.set("v.isSpinning",true);
        var pfMap = component.get("c.getPercentFieldMap");
        
        pfMap.setParams({objId: component.get("v.recordId"), 
                         sObjectAPIName: component.get("v.sObjectAPIName"), 
                         fieldSetAPIName: component.get("v.fieldSetAPIName")});
        pfMap.setCallback(this,function(returnJSON) {
            
        	var returnObj = JSON.parse(returnJSON.getReturnValue());
            
            if(returnObj != null) {
                component.set("v.mapDependentPicklistInfo", returnObj.mapCntrFieldListDependentWrapper);   
                component.set("v.selectedSObject", returnObj.sObj);
                component.set("v.mapFieldInfo", returnObj.mapOfFieldApiToFieldsInfo);
                component.set("v.fieldApiNames", returnObj.fieldApiNames);
                
                component.set("v.selectedSObjectCopy", JSON.stringify(returnObj.sObj)); 
            }
            
       		component.set("v.isSpinning",false);
        });
        $A.enqueueAction(pfMap);
        
        component.set("v.isStartClick", true); 
        var modalBox = component.find("modalBox");
        var modalBack = component.find("modalBack");
        $A.util.addClass(modalBox, 'slds-fade-in-open');
        $A.util.addClass(modalBack, 'slds-backdrop--open');
        component.set("v.modalStyle", ".forceStyle .viewport .oneHeader {z-index:0; } .slds-global-header_container {position: static;} .forceStyle.desktop .viewport{overflow:hidden}");
                      
   },
 
   closeMissingFieldsModal: function(component, event, helper) {
		component.set('v.isStartClick', false);
		var modalBox = component.find("modalBox");
		var modalBack = component.find("modalBack");
		$A.util.removeClass(modalBox, 'slds-fade-in-open');
		$A.util.removeClass(modalBack, 'slds-backdrop--open');
		   
		component.set("v.modalStyle", "");
		component.set("v.selectedSObject", JSON.parse(component.get("v.selectedSObjectCopy")));
   },
    
    saveRecord: function(component, event, helper) {
        
    	helper.saveRecord(component);
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