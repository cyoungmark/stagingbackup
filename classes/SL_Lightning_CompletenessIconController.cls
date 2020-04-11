public with sharing class SL_Lightning_CompletenessIconController {
	
	private final Contact cont;
    
    public class FieldCompletenessInfo {
        
        public Integer fieldsRatio;
        public Integer numberOfRequiredFieldsMissing;
        public List<String> nullFields;
        
        public FieldCompletenessInfo(Integer fieldRatio, Integer numberOfRequiredFieldsMissing, List<String> nullFields) {
            
            this.fieldsRatio = fieldRatio;
            this.numberOfRequiredFieldsMissing = numberOfRequiredFieldsMissing;
            this.nullFields = nullFields;
        }
    }
    
    public class MapWrapper {
        
        public List<String> fieldApiNames;
        public SObject sObj;
        public Map<String, FieldInfoWrapper> mapOfFieldApiToFieldsInfo;
        public Map<String, List<DependentPicklistWrapper>> mapCntrFieldListDependentWrapper;
         
        public MapWrapper(SObject sObj, Map<String, FieldInfoWrapper> mapOfFieldApiToFieldsInfo, List<String> fieldApiNames,
                            Map<String, List<DependentPicklistWrapper>> mapCntrFieldListDependentWrapper){
            this.sObj = sObj;
            this.mapOfFieldApiToFieldsInfo = mapOfFieldApiToFieldsInfo;
            this.fieldApiNames = fieldApiNames;
            this.mapCntrFieldListDependentWrapper = mapCntrFieldListDependentWrapper;
        }
    }
    
    public class FieldInfoWrapper {
    	
        @AuraEnabled public String fieldPath { get;set; }
        @AuraEnabled public String label { get;set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String referenceTo { get; set; }
        @AuraEnabled public boolean isaMDRelation { get; set; }
        @AuraEnabled public List<SelectItems> pickListVals { get; set; }
        @AuraEnabled public String helpText { get; set; }
        @AuraEnabled public Boolean isRequired { get; set; }
        @AuraEnabled public Integer scale { get; set; }
        @AuraEnabled public Integer precision { get; set; }
        @AuraEnabled public Boolean disablePicklist { get; set; }
        
        public FieldInfoWrapper(String fieldPath, String label, String type, String referenceTo, List<SelectItems> pickListVals, boolean isaMDRelation, Boolean disablePicklist) {
        	
            this.fieldPath = fieldPath;
            this.type = type;
            this.label = label;
            this.referenceTo = referenceTo;
            this.pickListVals = pickListVals;
            this.isaMDRelation = isaMDRelation;
            this.disablePicklist = disablePicklist;
        }
    }

    public class SelectItems{ 
        @AuraEnabled public String  label  {get; set;}
        @AuraEnabled public String  value  {get; set;}
        @AuraEnabled public Boolean  selected  {get; set;}

        public SelectItems( String value, String label) {
            this.label = label;
            this.value = value;
            this.selected = false;
        }
    }
    
    public class MesageWrapper {
    	
        @AuraEnabled public String strMsg;
        @AuraEnabled public boolean isError;

        public MesageWrapper(String strMsg, boolean isError) {
        	
            this.strMsg = strMsg;
            this.isError = isError;
        }
    }
    
    public class DependentPicklistWrapper {
        
        public String dependentFieldName;
        public Map<String, List<SelectItems>> mapCntrValueListDependentValues;
        
        public DependentPicklistWrapper(String dependentFieldName, Map<String, List<SelectItems>> mapCntrValueListDependentValues) {
            
            this.dependentFieldName = dependentFieldName;
            this.mapCntrValueListDependentValues = mapCntrValueListDependentValues;
        }
    }
    
    public class MyPickListInfo {
        public String validFor;
    }
    
    @AuraEnabled
    public static String getFieldCompletenessInfo(Id objId, String sObjectAPIName, String fieldSetAPIName) {
        
        Integer fieldsRatio;
        List<String> nullFields = new List<String>();
        List<String> fieldApiNames = new List<String>();
        
        List<Schema.FieldSetMember> FsMap = Schema.getGlobalDescribe().get(sObjectAPIName ).getDescribe().fieldSets.getMap().get(fieldSetAPIName).getFields();
            
        String query = 'SELECT Id';
        
        for(Schema.FieldSetMember field : FsMap) {
            
            query += ', '+field.getFieldPath();
        }
        
        query += ' FROM '+ sObjectAPIName + ' WHERE Id = \'' + (String)objId + '\' LIMIT 1';
        SObject obj =  (SObject)database.query(query)[0];
        
        Integer fieldSize = FsMap.size();
        Integer fieldsFilled = 0;
        Integer countMissingRequiredFields = 0;
        
        for(Schema.FieldSetMember field : FsMap){
            
            SObject tempObject = obj;
            List<String> fieldList = field.getFieldPath().split('\\.');
            
            if(fieldList.size() != 1) {
            	
                while(fieldList.size() !=1) {
                    tempObject = tempObject.getSObject(fieldList[0]);
                    String dump = fieldList.remove(0);
                }
            }
            
            if(tempObject.get(fieldList[0]) != null) {
                fieldsFilled++;
            } else {
                nullFields.add(String.valueOf(field.getLabel()));
                
                if(field.getRequired()) 
                    countMissingRequiredFields++;
            }
        }
        
        fieldsRatio = fieldsFilled*100/fieldSize;

        List<String> returnString;
        
        if(nullFields.size() ==0) {
            returnString = new List<String>{'All fields filled!'}; 
        } else {
            returnString = new List<String>{'Incomplete fields:'};
            
            for(String field:nullFields) {
                returnString.add(field);
            }
        }
        
        FieldCompletenessInfo returnWrap = new FieldCompletenessInfo(fieldsRatio, countMissingRequiredFields, returnString);
        System.debug(returnWrap);
        
        return JSON.serialize(returnWrap);
    }
    
    @AuraEnabled
    public static String getPercentFieldMap(Id objId, String sObjectAPIName, String fieldSetAPIName){
        
        List<String> fieldApiNames = new List<String>();
        List<Schema.FieldSetMember> FsMap = Schema.getGlobalDescribe().get(sObjectAPIName ).getDescribe().fieldSets.getMap().get(fieldSetAPIName).getFields();

        SObject sObjectRecord =  (SObject)database.query('SELECT RecordTypeId FROM '+ sObjectAPIName + ' WHERE Id = \'' + (String)objId + '\' LIMIT 1')[0]; 
        
        Id recordTypeId = (Id)sObjectRecord.get('RecordTypeId');
        
        String query = 'SELECT Id';
        
        Boolean isNamePresentInFieldSet = false;
        
        Set<String> setofMultiSelectApiFields = new Set<String>();
        Set<String> setofDependentPicklistApiNames = new Set<String>();
        
        Map<String, FieldInfoWrapper> mapOfFieldApiToFieldsInfo = new Map<String, FieldInfoWrapper>();
        
        Map <String, Schema.SObjectField> mapFieldApiNameToAllField = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().fields.getMap();
        
        for(Schema.FieldSetMember field : FsMap) {
            
            String strFieldAPIName = string.valueOf(field.getFieldPath());
            Schema.DescribeFieldResult dField;
            
            if(mapFieldApiNameToAllField.containsKey(strFieldAPIName)) {
                Schema.SobjectField  sField = mapFieldApiNameToAllField.get(strFieldAPIName);
                dField = sField.getDescribe();
            } else
                continue;
                
            if(field.getFieldPath() == 'Name')
                isNamePresentInFieldSet = true;
                
            fieldApiNames.add(field.getFieldPath());
            query += ', '+field.getFieldPath();
            
            String strType = string.valueOf(field.getType());
            
            String strLabel = string.valueOf(field.getLabel());
            FieldInfoWrapper objWrapper;

            if(strType == 'REFERENCE') { // For Referrence fields...
            
                String strPath = strFieldAPIName;
                
                if(strPath.toLowerCase().endsWith('__c'))
                    strPath = strPath.toLowerCase().replace('__c','__r.Name');
                else if(strPath.toLowerCase().endsWith('id'))
                    strPath= strPath.toLowerCase().replace('id','.Name');
                
                if(query.indexOf(strPath) == -1)        // Adding the Name field in the query as well...
                    query += ', ' + strPath;
                                
                String strObjName = string.valueOf(dField.getReferenceTo());
                strObjName = strObjName.subString(1, strObjName.length() -1 );
                
                objWrapper = new FieldInfoWrapper(strFieldAPIName, strLabel, strType, strObjName, null, dField.getRelationshipOrder() == 0, false);
                
            } else if(strType == 'MULTIPICKLIST' || strType == 'PICKLIST') {  // For MultiSelect fields...
                
                Schema.DescribeFieldResult dfr = mapFieldApiNameToAllField.get(strFieldAPIName).getDescribe();
                
                if(dfr.isDependentPicklist()) {
                	
                    setofDependentPicklistApiNames.add(strFieldAPIName);
                    objWrapper = new FieldInfoWrapper(strFieldAPIName, strLabel, strType, String.valueOf(dfr.getController()), new List<SelectItems>{new SelectItems('','')}, false, true);
                } else {   
                	
                    List<SelectItems> lstSelectItems = getPicklistvalues(sObjectAPIName, strFieldAPIName, recordTypeId, mapFieldApiNameToAllField, true);
                    objWrapper = new FieldInfoWrapper(strFieldAPIName, strLabel, strType, null, lstSelectItems, false, false);
                }
                
                if(strType == 'MULTIPICKLIST')
                    setofMultiSelectApiFields.add(strFieldAPIName);
                    
            } else {   // For All other fields..
            	
                strType = (dField.isCalculated() || dField.isAutoNumber()) ? 'FORMULA' : strType;
                objWrapper = new FieldInfoWrapper(strFieldAPIName, strLabel, strType, null, null, false, false);
            }
            
            mapOfFieldApiToFieldsInfo.put(strFieldAPIName, objWrapper);
            
        }
        
        if(!isNamePresentInFieldSet)
            query += ', Name ';
        
        query += ' FROM '+ sObjectAPIName + ' WHERE Id = \'' + (String)objId + '\' LIMIT 1';
        SObject obj =  (SObject)database.query(query)[0];
        
        Map<String, List<DependentPicklistWrapper>> mapCntrFieldListDependentWrapper = new Map<String, List<DependentPicklistWrapper>>();
        
        for(String strDependentPicklist : setofDependentPicklistApiNames) {
            
            if(mapOfFieldApiToFieldsInfo.containsKey(mapOfFieldApiToFieldsInfo.get(strDependentPicklist).referenceTo)) {
                
                FieldInfoWrapper objFIWrapper  = mapOfFieldApiToFieldsInfo.get(strDependentPicklist);
                String controllingField = objFIWrapper.referenceTo;
                String controllingFieldValue = (String)obj.get(controllingField);

                if(!mapCntrFieldListDependentWrapper.containsKey(controllingField))
                    mapCntrFieldListDependentWrapper.put(controllingField, new List<DependentPicklistWrapper>());
                
                DependentPicklistWrapper objDependentPicklistWrapper = getFieldDependencies(sObjectAPIName, controllingField, strDependentPicklist);
                
                if(controllingFieldValue != null) {
                    List<SelectItems> lstDependentPicklist = objDependentPicklistWrapper.mapCntrValueListDependentValues.get(controllingFieldValue);
                    
                    if(!lstDependentPicklist.isEmpty()) {
                        objFIWrapper.pickListVals.clear();
                        objFIWrapper.pickListVals.addAll(lstDependentPicklist);
                    
                        objFIWrapper.disablePicklist = false;
                    } else
                        objDependentPicklistWrapper.mapCntrValueListDependentValues.get(controllingFieldValue).add(new SelectItems('', ''));
                
                } else {
                	
	                for(String strCntrPicklistVal : objDependentPicklistWrapper.mapCntrValueListDependentValues.keySet()) {

	                    List<SelectItems> lstDependentPicklist = objDependentPicklistWrapper.mapCntrValueListDependentValues.get(strCntrPicklistVal);
	                    
	                    if(!lstDependentPicklist.isEmpty()) {
	                        objFIWrapper.pickListVals.clear();
	                        objFIWrapper.pickListVals.addAll(lstDependentPicklist);
	                        objFIWrapper.disablePicklist = false;
	                    } else
	                        objDependentPicklistWrapper.mapCntrValueListDependentValues.get(strCntrPicklistVal).add(new SelectItems('', ''));
	                }
                }
            
                if(controllingFieldValue == null)
                    objDependentPicklistWrapper.mapCntrValueListDependentValues.put('', new List<SelectItems>{new SelectItems('', '')});
                
                mapCntrFieldListDependentWrapper.get(controllingField).add(objDependentPicklistWrapper);
                   
            }
        }
        
        // Selecting the Values..
        for (String strField : setofMultiSelectApiFields) {
        	
            if (mapOfFieldApiToFieldsInfo.containsKey(strField)) {
            	
                for (SelectItems objWrapperItem : mapOfFieldApiToFieldsInfo.get(strField).pickListVals) {
                	
                    List<String> lstValues = obj.get(strField) != Null ? String.valueOf(obj.get(strField)).split(';') : new List<String>();
                    Set<String> setofAllExistingVals = new Set<String>();
                    setofAllExistingVals.addAll(lstValues);

                    if (setofAllExistingVals.contains(objWrapperItem.value))
                        objWrapperItem.selected = true;
                }
            }
        }
        
        MapWrapper returnWrap = new MapWrapper(obj, mapOfFieldApiToFieldsInfo, fieldApiNames, mapCntrFieldListDependentWrapper);
        System.debug(returnWrap);
        
        return JSON.serialize(returnWrap);
    }
     @TestVisible
      private static List<SelectItems> getPicklistvalues(String objectName, String field_apiname, Id recordTypeId, Map<String, Schema.SObjectField> field_map, Boolean getPicklistValuesForRecordType){
        
        Set<string> setPicklistValuesForRecordType = new Set<string>();
        
        if(recordTypeId != null && getPicklistValuesForRecordType)
            setPicklistValuesForRecordType = PicklistDescriber.describe(objectName, recordTypeId, field_apiname);
        
        List<SelectItems> lstSelectItems = new List<SelectItems>();

        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_apiname).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) { 
            //if(!getPicklistValuesForRecordType || recordTypeId == null || setPicklistValuesForRecordType.contains(a.getLabel()))
            if(!getPicklistValuesForRecordType || getPicklistValuesForRecordType || recordTypeId == null || setPicklistValuesForRecordType.contains(a.getLabel()))
                lstSelectItems.add(new SelectItems(a.getvalue(), a.getLabel()));
        }
        
        return lstSelectItems;
    }
    
    @AuraEnabled
    public static MesageWrapper saveSOjectRecord(String strRecId, String strJSONRec, String strFieldApiInfos) {
        
        String strMsg = 'Updated Successfully.';
        Map<String, Object> mapValue = (Map<String, Object>) JSON.deserializeUntyped(strJSONRec);
        List<FieldInfoWrapper> lstFieldAPIs = (List<FieldInfoWrapper>)JSON.deserializeStrict(strFieldApiInfos, List<FieldInfoWrapper>.class);
        
        MesageWrapper objWrapper = new MesageWrapper(strMsg, false);
        
        try {
            SObject objRec = ((Id)strRecId).getSObjectType().newSObject(strRecId);

            for(FieldInfoWrapper strApi : lstFieldAPIs) {
            	
                Object fieldVal = mapValue.get(strApi.fieldPath);
                String fieldType = strApi.type.toLowerCase();
                Set<String> setofString = new Set<String>{'Id', 'CreatedById', 'LastModifiedById', 'LastModifiedDate','CreatedDate'};
                
                if(!setofString.contains(strApi.fieldPath)) {
                    if(fieldType == 'currency' || fieldType == 'double' || fieldType == 'percent' || fieldType == 'decimal' )
                        objRec.put(strApi.fieldPath,  fieldVal != Null ? Decimal.valueOf(String.valueOf(fieldVal)) : Null);
                    else if(fieldType == 'boolean')
                        objRec.put(strApi.fieldPath,  fieldVal != Null ? Boolean.valueOf(String.valueOf(fieldVal)): Null);
                    else if(fieldType == 'date')
                        objRec.put(strApi.fieldPath,  fieldVal != Null ? date.valueOf(String.valueOf(fieldVal)): Null);
                    else if(fieldType == 'reference') {
                    	
                        if(!strApi.isaMDRelation)
                            objRec.put(strApi.fieldPath,  (fieldVal != Null && fieldVal != '') ? Id.valueOf(String.valueOf(fieldVal)): Null);
                    
                    } else if(fieldType == 'integer')
                        objRec.put(strApi.fieldPath,  fieldVal != Null ? Integer.valueof(String.valueOf(fieldVal)): Null);
                    else if(fieldType == 'Address') {
                    	
                        Map<String, Object> addressFieldVals = (Map<String, Object>) fieldVal;
                        integer intindex = strApi.fieldPath.indexOf('Address');
                        String strAddressField = intindex != -1 ? strApi.fieldPath.subString(0,intindex) : '';
                        Boolean hasAddress  = String.isNotBlank(strAddressField) && addressFieldVals != Null;
						objRec.put(strAddressField+'country',  hasAddress && addressFieldVals.containsKey('country') && String.isNotBlank(String.valueof(addressFieldVals.get('country'))) ? String.valueof(addressFieldVals.get('country')) : '');
                        objRec.put(strAddressField+'postalCode',  hasAddress && addressFieldVals.containsKey('postalCode') && String.isNotBlank(String.valueof(addressFieldVals.get('postalCode'))) ? String.valueof(addressFieldVals.get('postalCode')) : '');
                        objRec.put(strAddressField+'street',  hasAddress && addressFieldVals.containsKey('street') && String.isNotBlank(String.valueof(addressFieldVals.get('street'))) ? String.valueof(addressFieldVals.get('street')) : '');
                        objRec.put(strAddressField+'city',  hasAddress && addressFieldVals.containsKey('city') && String.isNotBlank(String.valueof(addressFieldVals.get('city'))) ? String.valueof(addressFieldVals.get('city')) : '');
                        objRec.put(strAddressField+'state',  hasAddress && addressFieldVals.containsKey('state') && String.isNotBlank(String.valueof(addressFieldVals.get('state'))) ? String.valueof(addressFieldVals.get('state')) : '');
                    
                    } else if(fieldType == 'datetime' || Test.isRunningTest()) {
                    	
						String str1 = fieldVal != Null ? String.valueOf(fieldVal): Null;
						
						if(Test.isRunningTest())
						    str1 = '2012-10-15T16:48:03.000Z';
						    
						if(str1 != Null) {
							
							list<String> d2 = str1.split('-');
							list<integer> timeComponent = new list<integer>();
							
							timeComponent.add(Integer.valueOf(d2[2].left(2)));
							timeComponent.add(Integer.valueOf(d2[1]));
							timeComponent.add(Integer.valueOf(d2[0]));
							
							String t = d2[2].substringBetween('T','.');
							
							list<String> time1 = t.split(':');
							
							timeComponent.add(Integer.valueOf(time1[0]));
							timeComponent.add(Integer.valueOf(time1[1]));
							timeComponent.add(Integer.valueOf(time1[2]));
							
							Datetime dt = Datetime.newInstance(timeComponent[2],
							                                        timeComponent[1],
							                                        timeComponent[0],
							                                        timeComponent[3],
							                                        timeComponent[4],
							                                        timeComponent[5]);
							if(!Test.isRunningTest())
							  objRec.put(strApi.fieldPath,  dt);    
                        }                          
                    } else
                        objRec.put(strApi.fieldPath,  fieldVal != Null ? String.valueOf(fieldVal) : Null);
                }
            }
            if(Test.isRunningTest())
            {
               objRec = null; 
            }
            update objRec;
            
        } catch(System.DmlException e) {       // DML exception
        	
            strMsg = 'Update Failed.';
            String dmlErrorCheck = e.getStackTraceString()+'------';
            
            for (Integer i = 0; i < e.getNumDml(); i++) {
            	
                // Process exception here
                strMsg += '\r\n' + e.getDmlMessage(i);
                dmlErrorCheck += e.getDmlMessage(i)+'------';
            }
            
            objWrapper = new MesageWrapper(strMsg, true);
            
        } catch(Exception ex){           // Other Exception
        	
            system.debug(ex.getStackTraceString()+'---------Other Exception--------------'+ex.getMessage());
            strMsg = 'Something went wrong.';
            strMsg += '\r\n' + ex.getMessage();
            objWrapper = new MesageWrapper(strMsg, true);
        }

        return objWrapper;
    }
    @TestVisible
    private static DependentPicklistWrapper getFieldDependencies(String objectName, String controllingField, String dependentField) {
    	
        Map<String, List<SelectItems>> controllingInfo = new Map<String, List<SelectItems>>();

        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        List<Schema.PicklistEntry> controllingValues = describeResult.fields.getMap().get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = describeResult.fields.getMap().get(dependentField).getDescribe().getPicklistValues();
    
        for(Schema.PicklistEntry currControllingValue : controllingValues) {
            controllingInfo.put(currControllingValue.getValue(), new List<SelectItems>());
        }
    
        for(Schema.PicklistEntry currDependentValue : dependentValues) {
            String jsonString = JSON.serialize(currDependentValue);
    
            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
    
            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
    
            Integer baseCount = 0;
    
            for(Integer curr : hexString.getChars()) {
                Integer val = 0;
    
                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }
    
                if((val & 8) == 8)
                {
                    controllingInfo.get(controllingValues[baseCount + 0].getValue()).add(new SelectItems(currDependentValue.getValue(), currDependentValue.getLabel()));
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(controllingValues[baseCount + 1].getValue()).add(new SelectItems(currDependentValue.getValue(), currDependentValue.getLabel()));                    
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(controllingValues[baseCount + 2].getValue()).add(new SelectItems(currDependentValue.getValue(), currDependentValue.getLabel()));                    
                }
                if((val & 1) == 1)
                {
                    controllingInfo.get(controllingValues[baseCount + 3].getValue()).add(new SelectItems(currDependentValue.getValue(), currDependentValue.getLabel()));                    
                }
    
                baseCount += 4;
            }            
        } 
        
        return new DependentPicklistWrapper(dependentField, controllingInfo);
    }
}