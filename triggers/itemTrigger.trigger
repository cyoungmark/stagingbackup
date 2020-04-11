trigger itemTrigger on Item__c (before insert, before update, after update, after insert) {
    
    itemTriggerHandler handler = new  itemTriggerHandler();
    if (Trigger.isInsert && Trigger.isAfter) {
        handler.afterInsert(Trigger.new);
    }
}