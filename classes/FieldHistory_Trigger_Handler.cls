/***********************************************************************************************************************
* Apex class name      : FieldHistory_Trigger_Handler
* Version              : 1.0
* Created Date         : 28/12/2017
* Description          : This class defines all the logic for the FieldHistory trigger
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------------------
* Jonathan Major                 28/12/2017    Initial version
------------------------------------------------------------------------------------------------------------------------
***********************************************************************************************************************/
public class FieldHistory_Trigger_Handler
{
    /**************************************************************************************
    * Method name: deleteNotNeededFieldHistoryRecords                                     *
    * Description:                                                                        *
    *   Deletes any HFT__Field_Histories__c record that was auto created after an Item    *
    *   In Process is created. These Fied History records are not needed since the parent *
    *   Item In Process is brand new                                                      *
    *                                                                                     *
    **************************************************************************************/
    public static void deleteNotNeededFieldHistoryRecords(Map<Id, HFT__Field_Histories__c> newMap, Map<Id, HFT__Field_Histories__c> oldMap)
    {
        System.debug('FieldHistory_Trigger_Handler::deleteNotNeededFieldHistoryRecords: method invoked...');

        List<String> recordsToProcess = new List<String>();

        for(HFT__Field_Histories__c record : [SELECT Id, CreatedDate, Item_Update__r.CreatedDate, HFT__Object_Name__c FROM HFT__Field_Histories__c WHERE Id IN : newMap.keySet() AND Item_Update__c != NULL AND HFT__Old_Value__c = NULL AND HFT__Object_Name__c = 'Item_Update__c'])
        {
            System.debug('FieldHistory_Trigger_Handler::deleteNotNeededFieldHistoryRecords: History Tracking Id: ' + record.Id + ', Item in process CreatedDate: ' + record.Item_Update__r.CreatedDate + ', History Tracking CreatedDate: ' + record.CreatedDate);

            if(record.Item_Update__r.CreatedDate <= record.CreatedDate && record.CreatedDate <= record.Item_Update__r.CreatedDate.addMinutes(2))
                recordsToProcess.add(record.Id);
        }

        System.debug('FieldHistory_Trigger_Handler::deleteNotNeededFieldHistoryRecords: about to delete ' + recordsToProcess.size() + ' records: ' + recordsToProcess);

        if(recordsToProcess.size() > 0)
            executeFieldHistoryRecordDelete(recordsToProcess);
    }

    @future
    private static void executeFieldHistoryRecordDelete(List<String> recordIds)
    {
        System.debug('FieldHistory_Trigger_Handler::executeFieldHistoryRecordDelete: method invoked...');

        List<HFT__Field_Histories__c> recordsToProcess =
        [
            SELECT Id
            FROM HFT__Field_Histories__c
            WHERE
                Id IN : recordIds
        ];

        if(recordsToProcess.size() > 0)
        {
            System.debug('FieldHistory_Trigger_Handler::executeFieldHistoryRecordDelete: about to delete these Field History records: ' + recordsToProcess);
            delete recordsToProcess;
        }
            
    }
}