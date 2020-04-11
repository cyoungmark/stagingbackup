/***********************************************************************************************************
* Apex trigger name    : FieldHistory
* Version              : 1.0
* Created Date         : 28/12/2017
* Description          : Trigger for the HFT__Field_Histories__c object.
*                           Trigger functionality is declared in "FieldHistory_Trigger_Handler" class
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------
* Jonathan Major                 28/12/2017    Initial version
------------------------------------------------------------------------------------------------------------
***********************************************************************************************************/
trigger FieldHistory on HFT__Field_Histories__c (after update)
{
    if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            FieldHistory_Trigger_Handler.deleteNotNeededFieldHistoryRecords(Trigger.newMap, Trigger.oldMap);
        }
    }
}