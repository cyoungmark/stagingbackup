@isTest
public class CustomRequestTypesControllerTest {
	static testMethod void testMethod1() 
	{
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
        testAccount.Inactive_Custom_Request_Types__c='test1';
        testAccount.Custom_Request_Types__c='test2';
		insert testAccount;
		
        List <String> options = new  List <String>();
        options.add('test');
		
		Test.StartTest(); 

			string s = CustomRequestTypesController.getOptions(String.valueOf( testAccount.Id));
        	s = CustomRequestTypesController.getInactiveOptions(String.valueOf( testAccount.Id));
			CustomRequestTypesController.setOptions (testAccount.Id,options);
        	system.debug(CustomRequestTypesController.UserHasAccess());

		Test.StopTest();
	}
    static testMethod void testMethod2() 
	{
        Id wineryRecType = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Winery_Account').getRecordTypeId();

        
		Account testAccount = new Account();
		testAccount.Name='Test Account';
        testAccount.RecordTypeId= wineryRecType;
		insert testAccount;
        
        Tours_and_Tastings__c tt = new Tours_and_Tastings__c ();
        tt.Number_of_Guests__c=2;
        tt.Request_Type__c='Retailer';
            
        insert tt;
        
        Tour_and_Tasting_Request__c ttr = new Tour_and_Tasting_Request__c();
        ttr.Winery__c = testAccount.Id;
        ttr.Tour_and_Tasting__c=tt.Id;
        ttr.Earliest_Start_Time__c='10:00 AM PDT';
        ttr.Latest_Start_Time__c='11:00 AM PDT';
        ttr.Earliest_Date_of_Visit__c=System.today() + 10;
        ttr.Latest_Date_of_Visit__c=System.today() + 20;
        ttr.Request_Type_text__c = 'Retailer';
        insert ttr;
        system.debug(ttr.Id);
		
        List <String> options = new  List <String>();
        options.add('test');
		
		Test.StartTest(); 
			TTCustomRequestTypeController.setOptions (ttr.Id,'test');
			List <string> s = TTCustomRequestTypeController.getOptions(String.valueOf( ttr.Id));
			
        	
        
			testAccount.Custom_Request_Types__c='';
			update testAccount; 
        	TTCustomRequestTypeController.setOptions (ttr.Id,'test');
        	s = TTCustomRequestTypeController.getOptions(String.valueOf( ttr.Id));

		Test.StopTest();
	}
    static testMethod void testMethod3() 
	{
        Id wineryRecType = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Winery_Account').getRecordTypeId();

        
		Account testAccount = new Account();
		testAccount.Name='Test Account';
        testAccount.RecordTypeId= wineryRecType;
		insert testAccount;
        
        Tours_and_Tastings__c tt = new Tours_and_Tastings__c ();
        tt.Number_of_Guests__c=2;
        tt.Request_Type__c='Retailer';
        insert tt;
        
        Tour_and_Tasting_Request__c ttr = new Tour_and_Tasting_Request__c();
        ttr.Winery__c = testAccount.Id;
        ttr.Tour_and_Tasting__c=tt.Id;
        ttr.Earliest_Start_Time__c='10:00 AM PDT';
        ttr.Latest_Start_Time__c='11:00 AM PDT';
        ttr.Earliest_Date_of_Visit__c=System.today() + 10;
        ttr.Latest_Date_of_Visit__c=System.today() + 20;
        ttr.Request_Type_text__c='Retailer';
        
        //insert ttr;
		
		Test.StartTest(); 

			String s  = CustomTTRCreate.getOptions(String.valueOf( testAccount.Id));
        	
			s = CustomTTRCreate.saveRecordContr (JSON.serialize(ttr));
		Test.StopTest();
	}
    
}