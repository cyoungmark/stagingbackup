@IsTest
public class WebToCaseFrameControllerTest {
    @isTest static void test1(){
        
        account a = new account(name='test');
        insert a;
        
        contact cont = new contact (LastName='test',AccountId=a.Id,email='test@test.com');
        insert cont;
        
        WebToCaseFrameController con = new WebToCaseFrameController();
        con.acctName = 'qwerty';
        con.c.Subject ='test';
        con.c.Description='test';
        con.c.SuppliedEmail='test@test.com';
        
        con.submitCase();
        
        }
    @isTest static void test2(){
        
        account a = new account(name='test');
        insert a;
        
        contact cont = new contact (LastName='test',AccountId=a.Id,email='test@test.com');
        insert cont;
        
        WebToCaseFrameController con = new WebToCaseFrameController();
        con.acctName = 'test';
        con.c.Subject ='test';
        con.c.Description='test';
        con.c.SuppliedEmail='test@test.com';
        
        con.submitCase();

        con.acctName = '';
        con.submitCase();
        }
}