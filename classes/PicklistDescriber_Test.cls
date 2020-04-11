@isTest
private class PicklistDescriber_Test {
    static testMethod void test() {
        Id recType1Id = [Select Id from RecordType Where SobjectType = 'Account' 
                                            AND DeveloperName like 'Terlato_Internal'].Id;
        PicklistDescriber.describe('Account', recType1Id, 'Industry');

    }
}