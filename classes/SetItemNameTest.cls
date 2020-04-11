@isTest(SeeAllData=true)
public with sharing class SetItemNameTest{

    public static testMethod void test() {
        Brand__c b = new Brand__c ();
        b.name ='test';
        b.Brand_Code_Marketing__c='123';
        User u = [Select Id from User where isActive=true limit 1];
        b.Marketing_Executive__c=u.id;
        b.Marketing_Manager__c=u.id;
        insert b;
        
        Item__c i = new Item__c();
        i.name='test';
        i.Marketing_Product_Name__c='test';
        i.Marketing_Product_Description__c='test';
        i.Brand__c=b.Id;
        i.Vintage__c='210';
        insert i;
        
        Item__c item = [select name from Item__c where Id=: i.Id];
        //system.AssertEquals (item.name,'test-2010-test');
        
      }
  }