@isTest
private class controller_formatted_datetime_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Tours_and_Tastings__c tours_and_tastings_Obj = new Tours_and_Tastings__c(
            First_Visit_to_Napa__c = false,
            First_Visit_to_Sonoma__c = false,
            Itinerary_Approved__c = false,
            Number_of_Guests__c = 1,
            Request_Type__c = 'Consumer');
    Insert tours_and_tastings_Obj; 
    test.stopTest();
  }
  static testMethod void test_getFormattedDatetime_UseCase1(){
    List<Tours_and_Tastings__c> tours_and_tastings_Obj  =  [SELECT First_Visit_to_Napa__c,First_Visit_to_Sonoma__c,Itinerary_Approved__c from Tours_and_Tastings__c];
    System.assertEquals(true,tours_and_tastings_Obj.size()>0);
    controller_formatted_datetime obj01 = new controller_formatted_datetime();
    obj01.date_time = DateTime.now();
    obj01.getFormattedDatetime();
  }
}