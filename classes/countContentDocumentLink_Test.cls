@isTest
private class countContentDocumentLink_Test {
    static testMethod void test() {
        Account acct = new Account(
                Name='TEST_ACCT',
                BillingCountryCode = 'US',
                BillingCity='Bannockburn',
                BillingStateCode='IL'
        );
        insert acct;
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        delete cdl;
    }
}