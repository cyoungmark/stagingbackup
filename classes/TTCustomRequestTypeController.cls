public class TTCustomRequestTypeController {
 	@AuraEnabled
     public static List <String> getOptions(String TTId){
    	 Tour_and_Tasting_Request__c tt = [select Winery__r.Custom_Request_Types__c,Request_Type_text__c,Request_Type__c from Tour_and_Tasting_Request__c where id =:TTId];
         List <String> ret = new List <String>();
         if (tt.Winery__r.Custom_Request_Types__c!=null && tt.Winery__r.Custom_Request_Types__c != ''){
             ret.add(tt.Winery__r.Custom_Request_Types__c);
             ret.add(tt.Request_Type_text__c);
         } else {
             Schema.DescribeFieldResult fieldResult = Tour_and_Tasting_Request__c.Request_Type__c.getDescribe();
             List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
             String picklistValues = '';
             for( Schema.PicklistEntry pickListVal : ple){
                 picklistValues += pickListVal.getValue() + '|';
             } 
             ret.add(picklistValues.removeEnd('|'));
             
             if (tt.Request_Type_text__c!=null && tt.Request_Type_text__c!=''){
                 ret.add(tt.Request_Type_text__c);
             } else {
             	ret.add(tt.Request_Type__c);
             }

         } 
            
         
         
         return ret;
     }
    @AuraEnabled
     public static String setOptions(String TTId, String options){
         try{
             Tour_and_Tasting_Request__c tt = [select Id, Request_Type_text__c from Tour_and_Tasting_Request__c where id =:TTId];
             tt.Request_Type_text__c = options;
             update tt;
             return 'Success';
         } catch (DmlException e){
             system.debug(e.getMessage());
             throw new AuraHandledException(e.getMessage());
         }
         
     }
    
}