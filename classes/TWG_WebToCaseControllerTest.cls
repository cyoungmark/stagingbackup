@IsTest
public class TWG_WebToCaseControllerTest {
    @isTest static void test1(){
        
        account a = new account(name='test');
        insert a;
        
        contact cont = new contact (LastName='test',AccountId=a.Id,email='test@test.com');
        insert cont;
        
        TWG_WebToCaseController con = new TWG_WebToCaseController();
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
        
        TWG_WebToCaseController con = new TWG_WebToCaseController();
        con.acctName = 'test';
        con.c.Subject ='test';
        con.c.Description='test';
        con.c.SuppliedEmail='test@test.com';
        
        con.submitCase();

        con.acctName = '';
        con.submitCase();
        }
}