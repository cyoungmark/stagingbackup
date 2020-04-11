@IsTest
public class sendEmailTest {
    @isTest static void setup(){
        
        account a = new account(name='test');
        insert a;
        
        contact con = new contact (LastName='test',Account=a,email='test@test.com');
        insert con;
        
        Case c = new Case();
        c.Status='New';
        c.ContactId=con.Id;
        c.Priority='Normal';
        c.Send_custom_email_notification__c=true;
        insert c;
        
         ApexPages.StandardController sc = new ApexPages.StandardController(c);
        sendEmailToCaseContact stdCon= new sendEmailToCaseContact(sc);
        
        PageReference pageRef = Page.SendEmailToCaseContact;
        pageRef.getParameters().put('id', String.valueOf(c.Id));
        Test.setCurrentPage(pageRef);
        stdCon.sendEmail();
        
        
        
        }
}