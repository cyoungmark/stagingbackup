/***********************************************************************************************************
* Apex trigger name    : Brand
* Version              : 1.0
* Created Date         : 27/12/2017
* Description          : Trigger for the Brand__c object.
*                           Trigger functionality is declared in "Brand_Trigger_Handler" class
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------
* Jonathan Major                 27/12/2017    Initial version
------------------------------------------------------------------------------------------------------------
***********************************************************************************************************/

trigger Brand on Brand__c (after update)
{
    if(Trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            Brand_Trigger_Handler.updateBrandManagers(Trigger.newMap, Trigger.oldMap);
        }
    }
}