public class itemTriggerHandler {
    public void afterInsert(List<Item__c> itemList) {
        Set<Id> idset = new Set<Id>();
        for (Item__c i : itemList) {
            idset.add(i.id);
        }
        SendIAtoJDE.makeJDECallout(idset);
    }
}