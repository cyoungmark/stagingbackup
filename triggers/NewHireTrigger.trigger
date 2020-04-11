trigger NewHireTrigger on Case (after insert, before update) {
if(checkRecursive.runOnce()&& Trigger.isInsert){
    set<Id> caseIds = new set<Id>();
    List <Task> tasklist = new List <Task> ();
    List <Case> caselist = new List <Case> ();
    
    for(case c: Trigger.new){
        if (c.Data_Category_SubGroup__c=='New Hire'){
            task task1 = new task();
            if (c.subject!=null){
                task1.subject=c.subject + ': Create Email Account';
            } else {
                task1.subject='Create Email Account';
            }
            task1.status='Not Started';
            task1.priority='Normal';
            task1.WhatId=c.Id;
            tasklist.add(task1);
            
            task task2 = new task();
            task2.subject='Setup Network ID';
            task2.status='Not Started';
            task2.priority='Normal';
            task2.WhatId=c.Id;
            tasklist.add(task2);
            
            task task3 = new task();
            task3.subject='Provide Building Access';
            task3.status='Not Started';
            task3.priority='Normal';
            task3.WhatId=c.Id;
            tasklist.add(task3);
            
            case case1 = new case();
            if (c.subject!=null){
                case1.subject=c.subject + ': Create Email Account';
            } else {
                case1.subject='Create Email Account';
            }
            if (c.ContactId!=null)
            case1.ContactId=c.ContactId;
            case1.ParentId=c.Id;
            case1.Status=c.Status;
            case1.Origin=c.Origin;
            caselist.add(case1);
            
            case case2 = new case();
            case2.subject='Setup Network ID';
            case2.ParentId=c.Id;
            case2.Status=c.Status;
            case2.Origin=c.Origin;
            if (c.ContactId!=null)
            case2.ContactId=c.ContactId;
            caselist.add(case2);
            
            case case3 = new case();
            case3.subject='Provide Building Access';
            case3.ParentId=c.Id;
            case3.Status=c.Status;
            case3.Origin=c.Origin;
            if (c.ContactId!=null)
            case3.ContactId=c.ContactId;
            caselist.add(case3);
           
            
        }
    }
    insert tasklist;
    insert caselist;
}
    if (Trigger.isUpdate){
        List <FeedItem> FeedItemList = new List <FeedItem> ();
         for (case c: Trigger.new){
                 case oldCase = Trigger.oldMap.get(c.ID);
            
                 if (c.Status=='Closed' &&  c.Status!=oldCase.Status && c.ParentId!=null){
                     FeedItem item = new FeedItem(
                        parentId = c.ParentId,
                        body = '<p>Case with id "' + c.Id + '" was closed</p>',
                        isRichText = true
                    );
                    FeedItemList.add(item);
                }
             }
        insert FeedItemList;
    }
}