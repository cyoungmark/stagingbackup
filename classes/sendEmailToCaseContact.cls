public with sharing class sendEmailToCaseContact{
    public Case cs {get; set;}

    public sendEmailToCaseContact(ApexPages.StandardController std) {     
        cs=(Case) std.getRecord();
        cs.Last_Comment__c='';
    }
    public void sendEmail (){
        system.debug(cs.Last_Comment__c);
        update cs;
        cs.Last_Comment__c='';
        
        EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Support_Case_Comment'];
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress limit 1];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            mail.setWhatId(cs.Id);
            mail.setTargetObjectId(cs.ContactId);
            mail.setSaveAsActivity(true);
            //mail.setUseSignature(false);
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }

        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail});
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Message was sent!');
            ApexPages.addMessage(msg);
            } catch(exception e){ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,e.getMessage());
        ApexPages.addMessage(msg);}
        
        
    

    }
}