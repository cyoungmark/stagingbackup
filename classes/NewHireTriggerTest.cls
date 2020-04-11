@IsTest
public class NewHireTriggerTest {
    @isTest static void setup(){
        
        account a = new account(name='test');
        insert a;
        
        contact con = new contact (LastName='test',Account=a,email='test@test.com');
        insert con;
        
        Case c = new Case();
        c.Status='New';
        c.ContactId=con.Id;
        c.Priority='Normal';
        c.Data_Category_SubGroup__c = 'New Hire';
        insert c;
        
        update c;
        
         
        
        
        
        }
}