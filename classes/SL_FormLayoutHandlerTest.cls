@isTest(seeAllData=true)
private class SL_FormLayoutHandlerTest {

    private static testMethod void test() {

        Account acc = new Account(
                Name = 'TestAcc',
                BillingCity='New York',
                BillingStateCode='NY',
                BillingCountryCode='US'
        );
        insert acc;

        String fieldset = SL_FormLayoutHandler.describeFieldSet('Item_Update__c', 'Cost_Fields');

        SL_FormLayoutHandler.getCurrentRecord('Account', 'Name,type', acc.Id);

        SL_FormLayoutHandler.updateRecord('Account', '[{"Id":"' + acc.Id + '", "Name": "updated Account"}]');



    }
}