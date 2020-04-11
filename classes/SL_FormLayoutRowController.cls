public with sharing class SL_FormLayoutRowController {

	@AuraEnabled
	public static list<map<string,string>> getselectOptions(string fld, sobject record) {

		list<map<string,string>> options = new list<map<string,string>>();
		options.add(new map<string,string>{'class' => 'optionClass', 'label' => '--None--', 'value' => ''});

		Schema.sObjectType objType = record.getSObjectType();
		map <String,Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

		for (Schema.PicklistEntry a: values) {
			options.add(new map<string,string>{'class' => 'optionClass', 'label' => a.getLabel(), 'value' => a.getValue()});
		}

		return options;
	}
}