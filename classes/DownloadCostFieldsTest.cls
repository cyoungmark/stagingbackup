@isTest
private class DownloadCostFieldsTest {
	@isTest static void test_method_one() {
        List<Item_Update__c> listItemUpdate = new List<Item_Update__c>();       

        User brandOwner = UtilitiesForTestMethodsClass.getUser('standarduser_test@silverlinecrm.com.sldev');
        List<sObject> customSettings = UtilitiesForTestMethodsClass.getCustomSetting();
        Item__c itemNew = UtilitiesForTestMethodsClass.getItemNew();
        State_Pricing__c statePricing = UtilitiesForTestMethodsClass.getStatePricing(itemNew.Id);

        Item_Update__c itemUpdate_copy = UtilitiesForTestMethodsClass.getItemUpdate('Item Update (Copy)', itemNew.Id);
        listItemUpdate.add(itemUpdate_copy);
        Item_Update__c itemUpdate_vintage_copy = UtilitiesForTestMethodsClass.getItemUpdate('New Item / Vintage (Copy)', itemNew.Id);
        listItemUpdate.add(itemUpdate_vintage_copy);
        Item_Update__c itemUpdate_unfinishedItem = UtilitiesForTestMethodsClass.getItemUpdate('Winery Unfinished Item (Copy)', itemNew.Id);
        listItemUpdate.add(itemUpdate_unfinishedItem);

        insert listItemUpdate;
        
        string s = DownloadCostFields.getFieldSet('Item_Update__c','Cost_Fields');
        s = DownloadCostFields.getRecords('Item_Update__c','["Id","Name"]');
    }
}