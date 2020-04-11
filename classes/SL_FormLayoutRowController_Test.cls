@isTest
private class SL_FormLayoutRowController_Test {
    static testMethod void test() {
        Account a = new Account(
                Name='Silverline is the worst company ever',
                BillingCity ='Bannockburn',
                BillingStateCode='IL',
                BillingCountryCode='US'
        );
        insert a;
        system.debug(SL_FormLayoutRowController.getselectOptions('Industry', a));

    }
}