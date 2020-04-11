/**  
* \arg ClassName        : SL_cmp_DynamicLookupController
* \arg JIRATicket       : 
* \arg CreatedOn        : 
* \arg LastModifiedOn   : 
* \arg CreatededBy      : 
* \arg ModifiedBy       : 
* \arg Description      : Apex Controller for looking up an SObject via SOQL
*/
public with sharing class SL_cmp_DynamicLookupController {
    
    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName) {                
        if(searchString != Null && sObjectAPIName != Null){
            // Sanitize the input
            searchString = String.escapeSingleQuotes(searchString).replace(' ','%');

            sObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
            
            List<Result> results = new List<Result>();
            
            searchString = '\'%' + searchString + '%\'';
            
            if(sObjectAPIName == 'User'){       // For user to get the Active Users..
                searchString += ' And IsActive=true ';
            }
            // Build our SOQL query
            String searchQuery = 'Select Id, Name From ' + sObjectAPIName + ' Where Name LIKE ' + searchString + ' Limit 50';
            
            system.debug('--searchQuery-----'+searchQuery);
            // Execute the Query
            List<SObject> searchList = Database.query(searchQuery);
     
            // Create a list of matches to return
            for (SObject so : searchList)
            {
                results.add(new Result((String)so.get('Name'), so.Id));
            }
            return results;
        }
        return new list<Result>();
    }
    
         
    /**
     * Inner class to wrap up an SObject Label, Id
     */
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
         
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }
}