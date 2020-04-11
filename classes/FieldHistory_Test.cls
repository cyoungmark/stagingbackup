@isTest
private class FieldHistory_Test {
    static testMethod void test() {
        HFT__Field_Histories__c fh = new HFT__Field_Histories__c();
        insert fh;
        update fh;
    }
}