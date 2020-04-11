({
	updateOpptyVal : function(component, valToUpdate){
	    
        var objRec = component.get('v.record');
		var fieldName = component.get("v.fieldApiName");
        
		if(fieldName.indexOf('Address') !== -1 && fieldName.indexOf('__c') === -1 ){            
            var addressInfo = objRec[fieldName] ? objRec[fieldName] : {street : '', state : '',postalCode : '',city : '',country : ''};
            addressInfo['street'] = component.get("v.StreetVal");
            addressInfo['state'] = component.get("v.StateVal");
            addressInfo['postalCode'] = component.get("v.PostalVal");
            addressInfo['city'] = component.get("v.CountryVal");
            addressInfo['country'] = component.get("v.CityVal");
            objRec[fieldName] = addressInfo; 
            
            var fieldValueForAddress = addressInfo.street+ '\n' + ( addressInfo.city ? (addressInfo.city + ', ') : '' ) +addressInfo.state+ ' ' +addressInfo.postalCode+ ' ' +addressInfo.country;
            component.set("v.fieldVal", fieldValueForAddress); 
		}else{
			objRec[fieldName] = valToUpdate;
		}
        
        component.set("v.record", objRec);
    }
})