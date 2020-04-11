public class ValidationRecordLEX {
	@AuraEnabled
    public static Boolean provideInformationModal(String idItemInProcess) {
        
        return [SELECT Id, 	to_lex_validation__c FROM Item_Update__c WHERE Id =: idItemInProcess].to_lex_validation__c;
    }
    
}