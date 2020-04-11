public with sharing class SL_FormLayoutHandler {

	public class FieldSetInfoWrapper {
	    
	    public List<String> fieldApiNames;
	    public Map<String, Object> mapOfFieldApiToFieldsInfo;
	    
	    public FieldSetInfoWrapper(List<String> fieldApiNames, Map<String, Object> mapOfFieldApiToFieldsInfo) {
	        
	        this.fieldApiNames = fieldApiNames;
	        this.mapOfFieldApiToFieldsInfo = mapOfFieldApiToFieldsInfo;
	    }
	}
	
	@AuraEnabled
	public static Sobject getCurrentRecord(String sObj, String fieldNames, String recordId) {
	    
	    system.debug('------sObj---'+sObj);
	    system.debug('------fieldNames---'+fieldNames);
	    system.debug('------recordId---'+recordId);
		return Database.query('SELECT '+fieldNames+' FROM '+sObj+' WHERE Id = \''+recordId+'\'');
	}
    
	@AuraEnabled
	public static String describeFieldSet(String objType, String fieldSetName) {
		try{
			Set<String> setEditableFields = getCreatableFields(objType);
            Map<String,String> HelpText = getHelpText(objType);
			List<String> lstFieldApiNames = new List<String>();
			Map<String, Object> result = new Map<String, Object>();
			Map<String, Schema.FieldSet> fsMap = Schema.getGlobalDescribe().get(objType).getDescribe().fieldSets.getMap();
			
			if(!fsMap.get(fieldSetName).getFields().isEmpty()) {

				for(Schema.FieldSetMember fsm : fsMap.get(fieldSetName).getFields()){
				    
				    system.debug('------getLabel---'+fsm.getLabel());
					Map<String, Object> record = new Map<String, Object>();
					record.put('label', fsm.getLabel());
					record.put('type', fsm.getType());
                    record.put('helpText', HelpText.get(fsm.getFieldPath()));
					record.put('fieldPath', fsm.getFieldPath());
					record.put('editable', setEditableFields.contains(fsm.getFieldPath()));
					result.put(fsm.getFieldPath(), record);
					lstFieldApiNames.add(fsm.getFieldPath());
				}
                
                FieldSetInfoWrapper objWrapper = new FieldSetInfoWrapper(lstFieldApiNames, result);
                return JSON.serialize(objWrapper);
        
			} else {
				return '[{"message":"There is no fields present in provided fieldset. Please add some fields","errorCode":"NO_FIELDS_EXIST"}]';
			}
		} catch(Exception e) {
			return '[{"message":"The requested resource does not exist","errorCode":"NOT_FOUND"}]';
		}
	}

	@AuraEnabled
	public static String updateRecord(String sObj, String jsonObjArr) {
		try {
			Type listType = Type.forName('List<' + sObj + '>');
			List<SObject> objs = (List<SObject>)JSON.deserialize(jsonObjArr, listType);
			update objs;
		} catch (Exception e) {
			return '[{"data":' + jsonObjArr + ',"message":"' + e.getMessage() + '","cause":"' + e.getCause() + '","typeName":"' + e.getTypeName() + '"}]';
		}

		return 'success';
	}

	private static Set<String> getCreatableFields(String objectName) {
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName).getDescribe().Fields.getMap();
		Set<String> setEditableFields = new Set<String>();
		for (Schema.SObjectField ft : fMap.values()){
			Schema.DescribeFieldResult fd = ft.getDescribe();
			if (fd.isCreateable() && !fd.isUnique() && fd.isUpdateable())
				setEditableFields.add(fd.getName());
		}
		return setEditableFields;
	}
    private static Map<String,String> getHelpText(String objectName) {
		Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName).getDescribe().Fields.getMap();
		Map<String,String> HelpText = new Map<String,String>();
		for (Schema.SObjectField ft : fMap.values()){
			Schema.DescribeFieldResult fd = ft.getDescribe();
            //if(fd.getInlineHelpText()!=null)
			HelpText.put(fd.getName(), fd.getInlineHelpText());
		}
		return HelpText;
	}
}