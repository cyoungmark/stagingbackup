public class CustomTTRCreate {
	@AuraEnabled
     public static String getOptions(String accId){
         system.debug(accId);
    	return [select Custom_Request_Types__c from Account where id =:accId].Custom_Request_Types__c;
     }
    
    @AuraEnabled
     public static String saveRecordContr(String TTrec){
         try{
             system.debug(TTrec);
             TTrec=TTrec.replace('[','').replaceAll(']','');
             system.debug(TTrec);
             Tour_and_Tasting_Request__c tt = (Tour_and_Tasting_Request__c)JSON.deserialize(TTrec,Tour_and_Tasting_Request__c.class);
             
            insert tt;
            return tt.Id;
         }catch(exception e){
            throw new AuraHandledException('Error: ' + e.getMessage());   
         }
         //return '';
     }
}