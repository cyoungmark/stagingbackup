@isTest
private class Test_Brand_Trigger_Handler {
	
	@isTest static void test_method_one() {

		Brand_trigger_statuses__c customSetting = new Brand_trigger_statuses__c();
		customSetting.Name = 'In Progress';
		insert customSetting;
		
		Brand__c brand = UtilitiesForTestMethodsClass.getBrand();

		Item_Update__c itemUpdate = UtilitiesForTestMethodsClass.getItemUpdate('Item Update (Copy)', UtilitiesForTestMethodsClass.getItemNew().Id);
		itemUpdate.Brand__c = brand.Id;
		itemUpdate.Approval_Status__c = 'In Progress';
		insert itemUpdate;

		brand.Marketing_Manager__c = UtilitiesForTestMethodsClass.getUser('silverlinesucks@neverhireusagain.com').Id;
		update brand;
	}

}