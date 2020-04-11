trigger LockIIPrecords on Item_Update__c (before update) {
    /*Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get('Item_Update__c');
    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get('IIPLocked_white_list_fields');
    set <String> whiteListFields = new set <String>();
    
    for(Schema.FieldSetMember fieldSetMemberObj : fieldSetObj.getFields()){
        whiteListFields.add(fieldSetMemberObj.getFieldPath().toLowercase());
    }
    
    Item_Update__c iipObject = new Item_Update__c();
    Schema.SObjectType objType = iipObject.getSObjectType(); 
    Map<String, Schema.SObjectField> M = Schema.SObjectType.Item_Update__c.fields.getMap(); 
    
    List<Profile> acceptedProfiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() and (Name='TWG Accounting' OR Name='System Administrator')];
    system.debug(acceptedProfiles.size());
    for (Item_Update__c obj: trigger.new){
        if (obj.Approval_Status__c=='Completed - Record Locked' && acceptedProfiles.size()==0){
            for (String str : M.keyset()) { 
                if(trigger.newMap.get(obj.Id).get(str) != trigger.oldMap.get(obj.Id).get(str)) { 
                    if (!whiteListFields.contains(str.toLowercase())){
                        system.debug(trigger.newMap.get(obj.Id).get(str));
                        system.debug(trigger.oldMap.get(obj.Id).get(str));
                        
                    	obj.addError('IIP record is in "Completed - Record Locked" state. IIP is locked.');
                    }
                } 
        	}	  
        }
    }*/
}