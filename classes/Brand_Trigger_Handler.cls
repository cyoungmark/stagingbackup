/***********************************************************************************************************************
* Apex class name      : Brand_Trigger_Handler
* Version              : 1.0
* Created Date         : 27/12/2017
* Description          : This class defines all the logic for the Brand trigger
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------------------
* Jonathan Major                 27/12/2017    Initial version
------------------------------------------------------------------------------------------------------------------------
***********************************************************************************************************************/
public class Brand_Trigger_Handler
{
    /********************************************************************************
    * Method name: updateBrandManagers                                              *
    * Description:                                                                  *
    *   Checks if the Brand manager has changed and updates all the Item-In Process * 
    *   records (if any) so that they reflect the Brand Marketing Manager.          *
    *   Only Item-In Process records that have a IU Status defined in the following *
    *   custom setting will be processed                                            *
    *      -Brand_trigger_statuses__c                                               *
    *                                                                               *
    ********************************************************************************/
    public static void updateBrandManagers(Map<Id, Brand__c> newMap, Map<Id, Brand__c> oldMap)
    {
        Map<String, String> brandNewManagerMap = new Map<String, String>();

        for(Brand__c record : newMap.values())
        {
            if(record.Marketing_Manager__c != null && record.Marketing_Manager__c != oldMap.get(record.Id).Marketing_Manager__c)
            {
                brandNewManagerMap.put(record.Id, record.Marketing_Manager__c);
            }
            
        }

        if(brandNewManagerMap.size() > 0)
        {
            List<String> statusValues = new List<String>();

            for(Brand_trigger_statuses__c element : Brand_trigger_statuses__c.getAll().values())
            {
                statusValues.add(element.Name);
            }

            List<Item_Update__c> itemsInProcessToUpdate = new List<Item_Update__c>();

            for(Item_Update__c itemInProcess : [SELECT Id, Brand__c, Approval_Status__c, Brand_Owner__c FROM Item_Update__c WHERE Brand__c IN : brandNewManagerMap.keySet() AND Approval_Status__c IN : statusValues])
            {
                itemInProcess.Brand_Owner__c = brandNewManagerMap.get(itemInProcess.Brand__c);
                itemsInProcessToUpdate.add(itemInProcess);
            }

            if(itemsInProcessToUpdate.size() > 0)
                update itemsInProcessToUpdate;
        }
    }
}