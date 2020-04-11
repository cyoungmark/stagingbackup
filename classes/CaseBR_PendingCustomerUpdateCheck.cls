global class CaseBR_PendingCustomerUpdateCheck implements Database.Batchable<sObject> {
    

  global Database.QueryLocator start(Database.BatchableContext BC)
  {
      if(Test.isRunningTest()){
          return Database.getQueryLocator([SELECT Id, Status, CreatedDate,LastModifiedDate,CaseNumber,Subject,Resolution__c,Root_Cause__c FROM Case WHERE Status ='Pending Customer Update']);
      } else {
    	return Database.getQueryLocator([SELECT Id, Status, CreatedDate,LastModifiedDate,CaseNumber,Subject,Resolution__c,Root_Cause__c FROM Case WHERE Status ='Pending Customer Update' and LastModifiedDate<:system.today().addDays(-7)]);
  	}  
  }


  global void execute(Database.BatchableContext BC, List<Case> scope){
      System.debug(scope.size());
      System.debug(scope);
      List <FeedItem> FeedItemList = new List <FeedItem> ();
      for (Case c: scope){
          c.Status='Closed';
          if (c.Resolution__c==null)
              c.Resolution__c='Auto close';
          if (c.Root_Cause__c==null)
              c.Root_Cause__c='Auto close';
          
          FeedItem item = new FeedItem(
                parentId = c.Id,
                body = '<p> Case "' + c.CaseNumber + ', ' +  c.Subject + '" : Pending Customer Update since ' + c.LastModifiedDate  + '. Customer Update Timeout expired. Case auto closed.</p>',
                isRichText = true
            );
            FeedItemList.add(item);
      }
      
      if (scope.size()>0){
          update scope;
          insert FeedItemList;
      }
  }

  /**
   * Called after all batches have been completed.
   */
  global void finish(Database.BatchableContext BC)
  {
  }
  

}