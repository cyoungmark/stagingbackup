@isTest
private class Test_ValidationRecordLEX {
	
	@isTest static void test_method_one()
	{
		Item__c itemNew = new Item__c(
				Name = 'Item - Active TEST',
				Base_Units_per_Case__c = '12'

		);
		insert itemNew;

		Item_Update__c itemInProgress = new Item_Update__c(
				IU_Type__c = 'New Item',
				Base_Units_per_Case__c = '12'
		);
		insert itemInProgress;

		ValidationRecordLEX.provideInformationModal(itemInProgress.Id); 
	}
}