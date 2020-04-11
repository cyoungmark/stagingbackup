@isTest
public with sharing class CaseBR_Test{
    public static testMethod void testBatch1() {
        Test.StartTest();
        
        case c = new case (status='Pending Customer Update',Data_Category_group__c ='New Hire/Term Related',Type='Help Desk');
        insert c;
              
        CaseBR_PendingCustomerUpdateCheck batch = new CaseBR_PendingCustomerUpdateCheck();
        Database.executeBatch(batch,1);
        
        CaseBR_NewHireTermRelatedCatCheck batch2 = new CaseBR_NewHireTermRelatedCatCheck();
        Database.executeBatch(batch2,1);
        
        CaseBR_StatusNewCheck batch3 = new CaseBR_StatusNewCheck();
        Database.executeBatch(batch3,1);
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
    	String jobId = System.schedule('Test', CRON_EXP, new CaseBR_Scheduler());
        Test.StopTest();
      }
  }