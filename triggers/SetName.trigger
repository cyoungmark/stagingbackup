trigger SetName on Item__c (before insert, before update) {
    list<Schema.PicklistEntry> PicklistEntries = Item__c.Vintage__c.getDescribe().getPicklistValues();
    map<String,String> ApiToLabel = new map<String,String>();
    for (Schema.PicklistEntry pe : PicklistEntries){
        ApiToLabel.put(pe.getValue(),pe.getLabel());
    }
    
    for (Item__c obj: trigger.new){
        String name ='';
        name = obj.Brand_Name__c + '-';
        if (obj.Vintage__c!=null){
            if (ApiToLabel.get(obj.Vintage__c)==null){
                name += obj.Vintage__c + '-';
            }else{
                name += ApiToLabel.get(obj.Vintage__c) + '-';
            }
        }
        
        name += obj.Marketing_Product_Name__c;
        integer l = name.length();
        if (l>80) l=80;
        obj.name=name.substring(0, l);
    }
    
      

}