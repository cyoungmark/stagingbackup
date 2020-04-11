public class PickListDescController {
    public Sobject sobj {get;set;}
    public String pickListFieldName {get;set;}        
    
    public PickListDescController() {
        Map<String, String> reqParams = ApexPages.currentPage().getParameters();
        String sobjId = reqParams.get('id');
        String recordTypeId = reqParams.get('recordTypeId');
        String recordTypeName = reqParams.get('recordTypeName');
        String sobjectTypeName = reqParams.get('sobjectType'); 
        this.pickListFieldName = reqParams.get('picklistFieldName'); 
        
        Schema.SobjectType sobjectType = null;
        
        if (sobjectTypeName != null && sobjectTypeName.trim().length() > 0) {
            sobjectType = Schema.getGlobalDescribe().get(sobjectTypeName);
            // create blank sobject record
            sobj = sobjectType.newSobject();
            system.debug('-----sobjId----'+sobjId);
            system.debug('-----recordTypeId----'+recordTypeId);
            system.debug('-----recordTypeName----'+recordTypeName);
            system.debug('-----sobjectTypeName----'+sobjectTypeName);
            system.debug('-----pickListFieldName----'+pickListFieldName);
            system.debug('-----sobj----'+sobj);
            
            sobj.put('RecordTypeId', recordTypeid);                                            
        }  
    }
}