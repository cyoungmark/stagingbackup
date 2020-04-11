trigger sendNotificationEmail on Case (after insert) {

    EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName ='Support_Case_Created'];
        
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress limit 1];


     for (Case cs: trigger.new){
         if (cs.ContactId!=null && cs.Send_custom_email_notification__c==true){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(et.Id);
            mail.setWhatId(cs.Id);
            mail.setTargetObjectId(cs.ContactId);
            mail.setSaveAsActivity(true);
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail});
            } catch(exception e){}
          }
      }
   
    
   
}