@isTest
private class PickListDescController_Test {
    static testMethod void test() {
        Account a = new Account(
                Name='I write lazy unit tests and charge way too much money for them',
                BillingCity ='Bannockburn',
                BillingStateCode='IL',
                BillingCountryCode = 'US'
        );
        insert a;
        PageReference pageRef = Page.PicklistDesc;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('id',a.id);
        ApexPages.currentPage().getParameters().put('recordTypeId','');
        ApexPages.currentPage().getParameters().put('recordTypeName','Terlato_Internal');
        ApexPages.currentPage().getParameters().put('sobjectType','Account'); 
        ApexPages.currentPage().getParameters().put('picklistFieldName','Industry'); 
        
        PickListDescController plc = new PickListDescController();

    }
}