public class CustomRequestTypesController {
    @AuraEnabled
     public static String getOptions(String accId){
    	return [select Custom_Request_Types__c from Account where id =:accId].Custom_Request_Types__c;
     }
    @AuraEnabled
     public static String getInactiveOptions(String accId){
    	return [select Inactive_Custom_Request_Types__c from Account where id =:accId].Inactive_Custom_Request_Types__c;
     }
    
    @AuraEnabled
    public static Boolean UserHasAccess() {
        List <PermissionSetAssignment> ps = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId=:UserInfo.getUserId() AND PermissionSet.Name = 'Manage_Winery_Request_Type'];
        system.debug(ps.size()>0);
        return ps.size()>0;
    }
    
    @AuraEnabled
     public static void setOptions(String accId, List <String> options){
         Account a = [select Id, Custom_Request_Types__c,Inactive_Custom_Request_Types__c from Account where id =:accId];
         
         Set <String> InactiveRT = new Set <String>();
         if (a.Inactive_Custom_Request_Types__c!=null){
         	InactiveRT = new Set <String>(a.Inactive_Custom_Request_Types__c.split ('\\|'));
         }
         
         //filter duplicates
         Set <String> wtDuplOptions = new Set <String>();
         wtDuplOptions.addAll(options);
         options.clear();
         options = new List<String>(wtDuplOptions);
         //filter duplicates end
         
         if(a.Custom_Request_Types__c!=null){
             for (String s:a.Custom_Request_Types__c.split ('\\|')){
                 if(!wtDuplOptions.contains(s)){
                     InactiveRT.add(s);
                 }
             }
         }
         
         for (String s : options){
             if(InactiveRT.contains(s)){
                 InactiveRT.remove(s);
             }
             
         }

         List <String> InactiveRTList = new List<String>(InactiveRT);
         a.Inactive_Custom_Request_Types__c = String.join(InactiveRTList, '|');
         a.Custom_Request_Types__c = String.join(options, '|');
		 update a;
     }
}