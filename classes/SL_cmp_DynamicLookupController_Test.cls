@isTest
private class SL_cmp_DynamicLookupController_Test {
    static testMethod void test() {
        SL_cmp_DynamicLookupController.lookup('test', 'User');
        SL_cmp_DynamicLookupController.lookup(null, null);
    }
}