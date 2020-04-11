@isTest
private class SL_Lightning_CompletenessIcon_Test {
    static testMethod void test() {
        Item__c i = new Item__c(Name='Test', Marketing_Product_Name__c='test' ,Marketing_Product_Description__c='test');
        insert i;
        System.debug(SL_Lightning_CompletenessIconController.getFieldCompletenessInfo(i.Id,'Item__c','Price_Info'));
        System.debug(SL_Lightning_CompletenessIconController.getPercentFieldMap(i.Id,'Item__c','Price_Info'));
        System.debug(SL_Lightning_CompletenessIconController.getPercentFieldMap(i.Id,'Item__c','Compliance_Required'));
        System.debug(SL_Lightning_CompletenessIconController.getPercentFieldMap(i.Id,'Item__c','Required_for_Operations_Approval'));
        System.debug(SL_Lightning_CompletenessIconController.getPercentFieldMap(i.Id,'Item__c','Required_for_Executive_Approval'));
        
        
    }
}