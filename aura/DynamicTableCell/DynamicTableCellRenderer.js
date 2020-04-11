({
    render: function(cmp, helper) {
        var ret = this.superRender();
        var isRef = cmp.get('v.curFld.isRef');
        var fldType = cmp.get('v.curFld.fldType');
        var cmpType = '';
        var attrs = {};
        
        if(isRef) {
            cmpType = 'c:Link';
            attrs['curFld'] = cmp.get('v.curFld');
            attrs['cellVal'] = cmp.get('v.cellVal');
            attrs['lkupId'] = cmp.get('v.lkupId');
        } else {
            
            if(fldType === 'STRING' || fldType==='ID' || fldType==='COMBOBOX' || 
               fldType==='ENCRYPTEDSTRING' || fldType==='BASE64' || 
               fldType==='PICKLIST') {
                
                cmpType = 'ui:outputRichText';
                
            } else if (fldType === 'DATE') {
                
                cmpType = 'ui:outputDate';
                
            } else if (fldType === 'DATETIME' || fldType === 'TIME') {
                
                cmpType = 'ui:outputDateTime';
                
            } else if (fldType === 'BOOLEAN') {
                
                cmpType = 'ui:outputCheckbox';
                
            } else if (fldType === 'CURRENCY') {
                
                cmpType = 'ui:outputCurrency';
                
            } else if (fldType === 'DOUBLE' || fldType === 'INTEGER') {
                
                cmpType = 'ui:outputNumber';
                
            } else if (fldType === 'PERCENT') {
                
                cmpType = 'ui:outputNumber';
                
            } else if (fldType === 'EMAIL') {
                
                cmpType = 'ui:outputEmail';
                
            } else if (fldType === 'PHONE') {
                
                cmpType = 'ui:outputPhone';
                
            } else if (fldType === 'TEXTAREA') {
                
                cmpType = 'ui:outputRichText';
                
            } else if (fldType === 'URL') {
                
                cmpType = 'ui:outputURL';
                
            }
            
            /* Not currently handling images */
            
            attrs.value = cmp.get('v.cellVal');
            if(fldType === 'PERCENT' && attrs.value) {
                attrs.value += '%';
            }
            
            if(fldType === 'DATE' && attrs.value) {
                attrs.format = 'M/DD/YYYY';
            }
            
            if(fldType === 'DATETIME' && attrs.value) {
                attrs.format = 'M/DD/YYYY h:mm a';
            }
        }
        
        $A.createComponent(cmpType, attrs, function(newCmp, status, statusMsgLst) {
            if(cmp.isValid()){
                var body = cmp.get('v.body');
                body.push(newCmp);
                cmp.set('v.body', body);
            }
        });
        return ret;
    }
})