({
    doInit : function(component, event, helper) {
        //console.log(component.get('v.record'));
        
        var fieldAPI = component.get('v.fieldApiName');
        var fieldLabel = component.get('v.fieldSetLabelVal');
        var sobjectRc = component.get('v.record');
        var fType = component.get('v.fieldType');
        var isEditableField = component.get('v.isEditable');
        var precision = component.get('v.precision');
        var scale = component.get('v.scale');
		var isReadOnly = component.get('v.isReadOnly');
        
        console.log("attempting to render fields, readonly = ",isReadOnly);
        if(precision){
            var numberFormat = '';
            for(var i = precision; i > 0; i--){
                if(i === scale){
                    numberFormat += '.';
                }
                numberFormat += '#';
            }
            component.set('v.numberFormat', numberFormat);
        }
        
        if(fType){
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
            
            var fieldVal = fieldAPI.indexOf('.') < 0 ? sobjectRc[fieldAPI] : getRecordValue(sobjectRc, fieldAPI);
            if(fieldVal){
                component.set('v.fieldVal', fieldVal);
            }

            console.log(fieldVal);
            console.log(fieldAPI);
            console.log(component.get("v.fieldType"));
            
            if(fType == 'REFERENCE') {

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
                
                if(!isReadOnly) {
                    $A.createComponent(
                        "c:cmp_SL_DynamicLookUp",
                        {	
                            sObjectAPIName : component.get("v.sObjectName"),
                            pluralLabel : (component.get("v.sObjectName")+ 's'),
                            selRecId : component.get("v.parentId"),
                            selRecName : component.get("v.fieldVal"),
                            isError : false,
                            isFilter : false
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
                
            }else if(!isReadOnly && (fType == 'MULTIPICKLIST' || fType == 'PICKLIST')){
                console.log("is picklist");
                var options = component.get('v.PickListVals');
                console.log(options);
                var values = [];
                options.forEach(function(element) {
                if(fType == 'MULTIPICKLIST' && element.selected){
                        
                        values.push(element.value);
                    }
                });
                
                if(fType == 'MULTIPICKLIST'){
                    component.set("v.mySelectedItems", values);
                    component.set("v.myOptions", options); 
                    
                    $A.createComponent(
                        "c:cmp_SL_MultiSelect_Option",
                        {
                            options : component.get("v.myOptions"),
                            selectedItems : component.get("v.mySelectedItems")
                        },
                        function(newButton, status, errorMessage){
                            if (status === "SUCCESS") {
                                                                                                
                                var targetCmp = component.find('multiPicklist');
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

                }else{
                	component.set("v.mySelectedItemsPickList", []);
                    component.set("v.mySelectedItemsPickList", options);
                }
                
            }
            else if(fType == 'ADDRESS'){
                var intindex = fieldAPI.indexOf('Address');
                var  addressName = fieldAPI.substring(0,intindex);
                component.set("v.AddressName", addressName);
                
                if(fieldVal){
                    fieldVal.street = fieldVal.street ? fieldVal.street : '';
                    fieldVal.city = fieldVal.city ? fieldVal.city : '';
                    fieldVal.state = fieldVal.state ? fieldVal.state : '';
                    fieldVal.postalCode = fieldVal.postalCode ? fieldVal.postalCode : '';
                    fieldVal.country = fieldVal.country ? fieldVal.country : '';
                    
                    var fieldValueForAddress = fieldVal.street+ '\n' +(fieldVal.city == '' ? ' ' : fieldVal.city+', ') +fieldVal.state+ ' ' +fieldVal.postalCode+ ' ' +fieldVal.country;
                    component.set("v.StreetVal", fieldVal.street);
                    component.set("v.StateVal", fieldVal.state);
                    component.set("v.CityVal", fieldVal.city);
                    component.set("v.PostalVal", fieldVal.postalCode);
                    component.set("v.CountryVal", fieldVal.country);
    
                    component.set("v.fieldVal", fieldValueForAddress);
                }
            }
            console.log("rendered");
        }
    },
    
    handleNavigation : function(component, event, helper) {
        var recId = component.get("v.parentId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    updateVal : function(component, event, helper){
        var updatedVal = event.getSource().get("v.value");
        console.log('--updatedVal--'+updatedVal);
        if(!$A.util.isUndefinedOrNull(updatedVal))
            helper.updateOpptyVal(component, updatedVal);
    },
    
    getSelectedRecordId : function(component, event, helper){
        var selectedLookUpId = event.getParam("selectedId");
        component.set('v.parentId', selectedLookUpId);
        component.set("v.fieldVal", event.getParam("selectedName"));
        helper.updateOpptyVal(component, selectedLookUpId);
    },
    
    handleSelectChangeEvent : function(component, event, helper){
        var items = event.getParam("values");
        if(!$A.util.isUndefinedOrNull(items)){
            if(items.length > 0){
                var stringstrMultival  = items.join(';');
                component.set('v.fieldVal', stringstrMultival);
                helper.updateOpptyVal(component, stringstrMultival);
            }
            else{
                component.set('v.fieldVal', '');
                helper.updateOpptyVal(component, '');
            }
        }
    },
    
    onSelectChange : function(component, event, helper){
        var selectCmp = component.find("levels");
        component.set("v.fieldVal", selectCmp.get("v.value"));
        helper.updateOpptyVal(component, selectCmp.get("v.value"));
        
        if(component.get('v.isControllingPicklist')) {
            var createEvent = component.getEvent("updatePicklistValues");
            createEvent.setParams({"cntrFieldName" : component.get("v.fieldApiName")});
            createEvent.setParams({"cntrFieldValue" : selectCmp.get("v.value")});
            createEvent.fire();
        }
    }    
})