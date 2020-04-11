@isTest
private class Test_ItemUpdate_Trigger_Handler {
    
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

        Test.StartTest();
            Item_Files__c itemFile = UtilitiesForTestMethodsClass.getItemFile(itemUpdate_copy.Id);
    
            itemUpdate_copy.Brand_Owner__c = brandOwner.Id;
            itemUpdate_copy.Item_designation__c = 'Winery only';
            itemUpdate_copy.Approval_Status__c = 'Completed - Record Locked';
    
            itemUpdate_vintage_copy.Approval_Status__c = 'Completed - Record Locked';
    
            itemUpdate_unfinishedItem.Approval_Status__c = 'Completed - Record Locked';
    
            statePricing.Item_Update__c = itemUpdate_copy.Id;
            update statePricing;
    
            UtilityTriggers.executedTriggers.remove('ItemUpdate_AfterUpdate');
            
            update listItemUpdate;
        Test.StopTest();
    }
        
}