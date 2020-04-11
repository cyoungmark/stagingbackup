trigger setDefaultRequestTypes on Account (before insert) {
    /*
    Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Winery_Account').getRecordTypeId();
    for (Account a : Trigger.new) {       
        if(a.RecordTypeId==AccRecordTypeId){
            a.Custom_Request_Types__c='Consumer Request|Distributor of Employee|Family and VIPs|Retailer / Restauranteur';
        } 
    }
	*/
}