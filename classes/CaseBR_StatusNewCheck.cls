global class CaseBR_StatusNewCheck implements Database.Batchable<sObject> {
    

  global Database.QueryLocator start(Database.BatchableContext BC)
  {
      if(Test.isRunningTest()){
          return Database.getQueryLocator([SELECT Id, Status, Business_days_without_updates__c,CaseNumber,Subject FROM Case]);
      } else {
          return Database.getQueryLocator([SELECT Id, Status, Business_days_without_updates__c,CaseNumber,Subject FROM Case WHERE Business_days_without_updates__c>3 and Status='New']);
      }
  }


  global void execute(Database.BatchableContext BC, List<Case> scope){
      System.debug(scope.size());
      System.debug(scope);
        string body='';
      for (Case c: scope){
        string url = Url.getSalesforceBaseURL().toExternalForm() + '/' + c.Id;
        body += 'The ticket "' + c.CaseNumber + ', ' +  c.Subject + ' ' + url + '"  remaining in New status for ' + (c.Business_days_without_updates__c).intValue() + ' business days.<br/><br/>\n\n';
      }
        List <User> users = new List <User>();
        users= [SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Help_Desk')];
         user Jeff = new User();
        try{
            Jeff = [SELECT Email FROM User where name ='Jeff Harrison' limit 1];
        }catch(exception e){}
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();          
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress limit 1];
                  
        for(User con : users){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String> addresses = new List<String>();
            email.setSubject('Aging Ticket Alert');
            email.setHTMLBody(body);
            //addresses.add(con.Email);
            //email.setToAddresses(addresses);
            email.setTargetObjectId(con.Id);
            if (Jeff.Email!=null){
                String[] bccEmail = new String[]{Jeff.Email};
                email.setBccAddresses(bccEmail);
                email.setBccSender(true);
            }
            email.saveAsActivity = false;
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            emails.add(email);
        }
            
      
      if (scope.size()>0){
          system.debug(emails);
          Messaging.SendEmailResult [] res = Messaging.sendEmail(emails);
      }
  }

  /**
   * Called after all batches have been completed.
   */
  global void finish(Database.BatchableContext BC)
  {
  }
  

}