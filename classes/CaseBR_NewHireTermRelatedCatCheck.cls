global class CaseBR_NewHireTermRelatedCatCheck implements Database.Batchable<sObject> {
    

  global Database.QueryLocator start(Database.BatchableContext BC)
  {
      if(Test.isRunningTest()){
          return Database.getQueryLocator([SELECT Id, Status, CreatedDate,LastModifiedDate,CaseNumber,Subject,Data_Category_group__c FROM Case WHERE Data_Category_group__c ='New Hire/Term Related']);
      } else {
    	  return Database.getQueryLocator([SELECT Id, Status, CreatedDate,LastModifiedDate,CaseNumber,Subject,Data_Category_group__c FROM Case WHERE Data_Category_group__c ='New Hire/Term Related' and CreatedDate<:system.today().addDays(-58) and CreatedDate>=:system.today().addDays(-59)]);
  
      }
  }


  global void execute(Database.BatchableContext BC, List<Case> scope){
      System.debug(scope.size());
      System.debug(scope);
      List <FeedItem> FeedItemList = new List <FeedItem> ();
      for (Case c: scope){
          FeedItem item = new FeedItem(
                parentId = c.Id,
                body = '<p>New Hire/Term Case "' + c.CaseNumber + ', ' +  c.Subject + '"  created 60 days ago.</p>',
                isRichText = true
            );
            FeedItemList.add(item);
      }
      
      if (scope.size()>0){
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