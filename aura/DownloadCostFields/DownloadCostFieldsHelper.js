({
    
   convertArrayOfObjectsToCSV : function(component,objectRecords,setfieldNames){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        var keys = [];
        var keysLabel = [];
        setfieldNames.forEach(v => keys.push(v.name));
        setfieldNames.forEach(v => keysLabel.push(v.label));
        //keys = ['Id','Name','ci_cc_F1_BAF__c','ci_cc_F1_BAF_Warehouse__c' ];
        
        csvStringResult = '';
        csvStringResult += keysLabel.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
 
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
                 if (objectRecords[i][skey]==null){
                     csvStringResult += '"'+'"';
                 } else {
                     csvStringResult += '"'+ objectRecords[i][skey]+'"';
                 }
                
               
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
    doInit : function(component, event, helper) {
    	helper.getTableFieldSet(component, event, helper);
	},

    getTableFieldSet : function(component, event, helper) {
        var action = component.get("c.getFieldSet");
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldSetName: component.get("v.fieldSetName")
        });

        action.setCallback(this, function(response) {
            var fieldSetObj = JSON.parse(response.getReturnValue());
            component.set("v.fieldSetValues", fieldSetObj);
            //Call helper method to fetch the records
            helper.getTableRows(component, event, helper);
        })
        $A.enqueueAction(action);
    },

    getTableRows : function(component, event, helper){
        var action = component.get("c.getRecords");
        var fieldSetValues = component.get("v.fieldSetValues");
        var setfieldNames = new Set();
        for(var c=0, clang=fieldSetValues.length; c<clang; c++){             
            if(!setfieldNames.has(fieldSetValues[c].name)) {                 
                setfieldNames.add(fieldSetValues[c].name);                   
                if(fieldSetValues[c].type == 'REFERENCE') {                     
                    if(fieldSetValues[c].name.indexOf('__c') == -1) {                     	
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('Id')) + '.Name'); 
                    }                     
                    else {
                        setfieldNames.add(fieldSetValues[c].name.substring(0, fieldSetValues[c].name.indexOf('__c')) + '__r.Name');
                    }                 
                }             
            }         
        }         
        var arrfieldNames = [];         
        setfieldNames.forEach(v => arrfieldNames.push(v));
        //console.log(arrfieldNames);
        action.setParams({
            sObjectName: component.get("v.sObjectName"),
            fieldNameJson: JSON.stringify(arrfieldNames)
        });
        action.setCallback(this, function(response) {
            var list = JSON.parse(response.getReturnValue());
            //console.log(list);
            component.set("v.tableRecords", list);
        })
        $A.enqueueAction(action);
    },
})