@isTest
private class SL_ctrl_DynTbl_Test 
{
    @isTest 
    static void test_dynQry() 
    {
        Group g = new Group(Name = 'Test SL_ctrl_DynTbl_Test group');
        insert g;

        User u = [select id from User where isactive=true limit 1];
        GroupMember o = new GroupMember(GroupId=g.Id, userorgroupid=u.id);
        insert o;

        Test.startTest();
        // Test without a given sort field or sort direction
        SL_ctrl_DynTbl.dynQry('Id,Name', 'Group', '', '', '', '', '', '', false);

        // Test with all parameters
            String jsonReturnVal = SL_ctrl_DynTbl.dynQry('Id,GroupId,UserOrGroupId,Group.CreatedDate,Group.CreatedBy.Name', 
                                                     'GroupMember', 
                                                     'GroupId', 
                                                     'DESC',
                                                     'ownerId=currentuser',
                                                     g.Id,
                                                     'GroupId', '', false);
        
        //test parent field sort
        SL_ctrl_DynTbl.dynQry('Id,GroupId,UserOrGroupId,Group.CreatedDate,Group.CreatedBy.Name', 
                                                     'GroupMember', 
                                                     'GroupId', 
                                                     'DESC',
                                                     'ownerId=current_user_contact',
                                                     g.Id,
                                                     'GroupId', 'RelatedId', true);
        SL_ctrl_DynTbl.deleteRecord(g.Id);                                          
        Test.stopTest();
    }

    @isTest 
    static void testFilter()
    {
        Account acct = new Account();
        acct.Name = 'Test Account';
        acct.BillingCity='Bannockburn';
        acct.BillingStateCode='IL';
        acct.BillingCountryCode='US';
        insert acct;

        Contact ct1 = new Contact();
        ct1.AccountId = acct.Id;
        ct1.LastName = 'Schmo';

        Contact ct2 = new Contact();
        ct2.AccountId = acct.Id;
        ct2.LastName = 'Jones';

        List<Contact> contacts = new List<Contact>();
        contacts.add(ct1);
        contacts.add(ct2);
        insert contacts;

        Test.startTest();
        SL_ctrl_DynTbl.dynQry('Id,LastName','Contact','LastName','DESC',
                              'AccountId = <<Account.Id>>',
                               acct.Id,'', '', true);
        Test.stopTest();
    }
}