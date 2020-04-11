@isTest
private class Test_FieldHistory_Trigger_Handler {
	
	@isTest static void test_method_one() {
		HFT__Field_Histories__c fieldHistory = UtilitiesForTestMethodsClass.getFieldHistory();
		fieldHistory.Field_Label__c = 'Label test';
		update fieldHistory;
	}	
}