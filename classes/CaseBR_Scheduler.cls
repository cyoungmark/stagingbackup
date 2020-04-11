public with sharing class CaseBR_Scheduler implements Schedulable {
  
  public void execute(SchedulableContext SC) {
    CaseBR_PendingCustomerUpdateCheck batch = new CaseBR_PendingCustomerUpdateCheck(); 
    Database.executeBatch(batch);
    CaseBR_NewHireTermRelatedCatCheck  batch2 = new CaseBR_NewHireTermRelatedCatCheck (); 
    Database.executeBatch(batch2);
    CaseBR_StatusNewCheck batch3 = new CaseBR_StatusNewCheck (); 
    Database.executeBatch(batch3);
  }
}