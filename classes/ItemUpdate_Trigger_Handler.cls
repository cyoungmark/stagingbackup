/***********************************************************************************************************************
* Apex class name      : ItemUpdate_Trigger_Handler
* Version              : 1.0
* Created Date         : 12/12/2017
* Description          : This class defines all the logic for the ItemUpdate trigger
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------------------
* Jonathan Major                 12/12/2017    Initial version
* Diwaker Beesa                  08/30/2018    revision version
------------------------------------------------------------------------------------------------------------------------
***********************************************************************************************************************/
public class ItemUpdate_Trigger_Handler
{
    /****************************************************************************
    * Method name: autopupulateFields                                           *
    * Description:                                                              *
    *   Autopopulates fields, once a user selects the related Item and one of   *
    *   the following IU types                                                  *
    *      -Item Update (Copy)                                                  *
    *      -New Item / Vintage (Copy)                                           *
    *      -Winery Unfinished Item (Copy)                                       *
    *                                                                           *
    *   Fields to copy from the Item to the Item Update are defined on the      *
    *   corresponding custom setting:                                           *
    *       -Fields: Item Update (Copy)                                         *
    *       -Fields: New Item/Vintage (Copy)                                    *
    *       -Fields: Winery Unfinished Item (Copy)                              *
    *                                                                           *
    ****************************************************************************/
    public static Boolean isCFICalculation = true;
    public static void autopupulateFields(List<Item_Update__c> recordsList)
    {
        System.debug('ItemUpdate_Trigger_Handler::autopupulateFields: method invoked... checking if conditions apply');

        List<Item_Update__c> recordsToProcess = new List<Item_Update__c>();
        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' || record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
            {
                if(record.Item__c == NULL)
                    record.Item__c.addError('You have selected an option which requires an Item to copy from. Please select your item in the above field.');
                else
                    recordsToProcess.add(record);
            }
        }

        if(recordsToProcess.size() > 0)
            executeAutopopulateMethod(recordsToProcess);

    }

    private static void executeAutopopulateMethod(List<Item_Update__c> recordsList)
    {
        String stringIdsItemToCopy = '';
        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' || record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
            {
                stringIdsItemToCopy += '\'' + record.Item__c + '\', ';
            }
        }
        if(stringIdsItemToCopy.endsWith(', '))
            stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');

        String queryItemUpdateCopy = 'SELECT Id';

        for(Fields_Item_Update_Copy_A__c element : Fields_Item_Update_Copy_A__c.getAll().values())
        {
            queryItemUpdateCopy += ', ' + element.Name;
        }

        for(Fields_New_Item_Vintage_Copy_A__c element : Fields_New_Item_Vintage_Copy_A__c.getAll().values())
        {
            if(!queryItemUpdateCopy.contains(', ' + element.Name))
                queryItemUpdateCopy += ', ' + element.Name;
        }

        for(Fields_Winery_Unfinished_Item_Copy_A__c element : Fields_Winery_Unfinished_Item_Copy_A__c.getAll().values())
        {
            if(!queryItemUpdateCopy.contains(', ' + element.Name))
                queryItemUpdateCopy += ', ' + element.Name;
        }


        queryItemUpdateCopy += ' FROM Item__c WHERE Id IN (' + stringIdsItemToCopy + ')';
        System.debug('ItemUpdate_Trigger_Handler::autopupulateFields: queryItemUpdateCopy: ' + queryItemUpdateCopy);


        Map<Id, Item__c> itemsMap = new Map<Id, Item__c>();

        for(SObject record : Database.query(queryItemUpdateCopy))
        {
            itemsMap.put(record.Id, (Item__c)record);
        }

        String relationshipName = '';
        String fieldName = '';

        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' )
            {
                for(Fields_Item_Update_Copy_A__c element : Fields_Item_Update_Copy_A__c.getAll().values())
                {
                    if(element.Name.contains('__r.'))
                    {
                        relationshipName = element.Name.substringBefore('.');
                        fieldName = element.Name.substringAfter('__r.');

                        if(itemsMap.get(record.Item__c).getSobject(relationshipName) != null)
                        {
                            System.debug('element.Item_In_Process_field_API_name__c: ' + element.Item_In_Process_field_API_name__c);
                            System.debug('itemsMap.get(record.Item__c): ' + itemsMap.get(record.Item__c));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));

                            record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));
                        }
                    }
                    else
                    {
                        record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).get(element.Name));
                    }
                }
            }
            else if( record.IU_Type__c == 'New Item / Vintage (Copy)' )
            {
                for(Fields_New_Item_Vintage_Copy_A__c element : Fields_New_Item_Vintage_Copy_A__c.getAll().values())
                {
                    if(element.Name.contains('__r.'))
                    {
                        relationshipName = element.Name.substringBefore('.');
                        fieldName = element.Name.substringAfter('__r.');

                        if(itemsMap.get(record.Item__c).getSobject(relationshipName) != null)
                        {
                            System.debug('element.Item_In_Process_field_API_name__c: ' + element.Item_In_Process_field_API_name__c);
                            System.debug('itemsMap.get(record.Item__c): ' + itemsMap.get(record.Item__c));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));

                            record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));
                        }
                    }
                    else
                    {
                        record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).get(element.Name));
                    }
                }
            }
            else if( record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
            {
                for(Fields_Winery_Unfinished_Item_Copy_A__c element : Fields_Winery_Unfinished_Item_Copy_A__c.getAll().values())
                {
                    if(element.Name.contains('__r.'))
                    {
                        relationshipName = element.Name.substringBefore('.');
                        fieldName = element.Name.substringAfter('__r.');

                        if(itemsMap.get(record.Item__c).getSobject(relationshipName) != null)
                        {
                            System.debug('element.Item_In_Process_field_API_name__c: ' + element.Item_In_Process_field_API_name__c);
                            System.debug('itemsMap.get(record.Item__c): ' + itemsMap.get(record.Item__c));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName));
                            System.debug('itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName): ' + itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));

                            record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).getSobject(relationshipName).get(fieldName));
                        }
                    }
                    else
                    {
                        record.put(element.Item_In_Process_field_API_name__c, itemsMap.get(record.Item__c).get(element.Name));
                    }
                }
            }
        }
    }


    /*******************************************************************************
    * Method name: copyStatePricingRecords                                         *
    * Description:                                                                 *
    *   Clones the State pricing records related to the item and attaches them to  *
    *   the Item Update being created where the UI type is one of the following    *
    *   UI Types:                                                                  *
    *       -New Item / Vintage (Copy)                                             *
    *       -Item Update (Copy)                                                    *
    *       -Winery Unfinished Item (Copy)                                         *
    *                                                                              *
    *   Also removes the related item value if the UI item is one of the following *
    *       -New Item / Vintage (Copy)                                             *
    *       -Winery Unfinished Item (Copy)                                         *
    *   this is done by an asynchronous method named setItemValueToBlank           *
    *                                                                              *
    *******************************************************************************/
    public static void copyStatePricingRecords(List<Item_Update__c> recordsList)
    {
        System.debug('ItemUpdate_Trigger_Handler::copyStatePricingRecords: method invoked... checking if conditions apply');

        List<Item_Update__c> recordsToProcess = new List<Item_Update__c>();
        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' || record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
            {
                recordsToProcess.add(record);
            }
        }

        if(recordsToProcess.size() > 0)
            executeCopyStatePricingRecordsMethod(recordsToProcess);
    }


    /*******************************************************************************
    * Method name: relateItemInProcessWithItemActive                               *
    * Description:                                                                 *
    *   When a user starts an Item - IN Process and chooses Item Update (Copy):    *
    *       -Populate the Active_Item_Update__c field on the Item - Active record  *
    *        so that we know if there are any Current Updates for that record      *
    *                                                                              *
    *******************************************************************************/
    public static void relateItemInProcessWithItemActive(List<Item_Update__c> recordsList)
    {
        System.debug('ItemUpdate_Trigger_Handler::relateItemInProcessWithItemActive: method invoked... checking if conditions apply');

        List<SObject> itemsActiveToUpdate = new List<SObject>();

        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' && record.Item__c != null )
            {
                Item__c itemActive = new Item__c();

                itemActive.put('Id', record.Item__c);
                itemActive.put('Active_Item_Update__c', record.Id);


                itemsActiveToUpdate.add(itemActive);
            }
        }

        if(itemsActiveToUpdate.size() > 0)
            update itemsActiveToUpdate;
    }



    private static void executeCopyStatePricingRecordsMethod(List<Item_Update__c> recordsList)
    {
        Set<String> iuTypesToRemoveLookup = new Set<String>();

        for(IU_types_to_remove_lookup__c element : IU_types_to_remove_lookup__c.getAll().values())
        {
            iuTypesToRemoveLookup.add(element.Name);
        }
        System.debug('ItemUpdate_Trigger_Handler::copyStatePricingRecords: iuTypesToRemoveLookup: ' + iuTypesToRemoveLookup);

        String stringIdsItemToCopy = '';
        for(Item_Update__c record : recordsList)
        {
            if( record.IU_Type__c == 'Item Update (Copy)' || record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
            {
                stringIdsItemToCopy += '\'' + record.Item__c + '\', ';
            }
        }
        if(stringIdsItemToCopy.endsWith(', '))
            stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');

        String queryStatesPricing = 'SELECT Id, Item__c';

        for(Fields_State_pricing_A__c element : Fields_State_pricing_A__c.getAll().values())
        {
            queryStatesPricing += ', ' + element.Name;
        }

        queryStatesPricing += ' FROM State_Pricing__c WHERE Item__c IN (' + stringIdsItemToCopy + ')';
        System.debug('ItemUpdate_Trigger_Handler::copyStatePricingRecords: queryStatesPricing: ' + queryStatesPricing);

        Map<String, List<State_Pricing__c>> statePricingsMap = new Map<String, List<State_Pricing__c>>();

        for(SObject record : Database.query(queryStatesPricing))
        {
            State_Pricing__c tmp = (State_Pricing__c)record;

            if(!statePricingsMap.containsKey(tmp.Item__c))
            {
                statePricingsMap.put(tmp.Item__c, new List<State_Pricing__c>{tmp});
            }
            else
            {
                statePricingsMap.get(tmp.Item__c).add(tmp);
            }
        }

        System.debug('ItemUpdate_Trigger_Handler::copyStatePricingRecords: statePricingsMap: ' + statePricingsMap);

        List<State_Pricing__c> statePricingRecordsToCopy = new List<State_Pricing__c>();

        if(statePricingsMap.size() > 0)
        {	
            Id recordTypeId = Schema.SObjectType.State_Pricing__c.getRecordTypeInfosByDeveloperName().get('Locked').getRecordTypeId();
            for(Item_Update__c record : recordsList)
            {
                if( record.IU_Type__c == 'Item Update (Copy)' || record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' )
                {	
                    boolean hasILState = false;
                    boolean hasNYState = false;
                    boolean hasNJState = false;
                    for(State_Pricing__c sp : statePricingsMap.get(record.Item__c))
                    {	
                        if(sp.State__c!=null && sp.State__c=='IL'){
                            hasILState=true;
                        }
                        if(sp.State__c!=null && sp.State__c=='NY'){
                            hasNYState=true;
                        }
                        if(sp.State__c!=null && sp.State__c=='NJ'){
                            hasNJState=true;
                        }
                        State_Pricing__c newSP = new State_Pricing__c();
                        newSP.put('Item_Update__c', record.Id);
                        newSP.put('Trigger_Lookup__c', sp.Id);
                        newSP.put('RecordTypeId', recordTypeId);
                        newSP.put('Locked__c', true);

                        for(Fields_State_pricing_A__c element : Fields_State_pricing_A__c.getAll().values())
                        {	
                            newSP.put(element.Target_field_API_name__c, sp.get(element.Name));
                        }

                        statePricingRecordsToCopy.add(newSP);
                    }
                    
                    if (!hasILState){
                        State_Pricing__c newSP = new State_Pricing__c();
                        newSP.put('Item_Update__c', record.Id);
                        newSP.Locked__c = true;
                        newSP.RecordTypeId=recordTypeId;
                        newSP.State__c = 'IL';
                        newSP.Start_Date__c = Date.newInstance(1990, 01, 01);
                        newSP.End_Date__c = System.today() + 7305;
                        newSP.State_Adjustment__c	= 0;
                        newSP.Old_State_Adjustment__c = 0;
                        statePricingRecordsToCopy.add(newSP);
                    }
                    if (!hasNYState){
                        State_Pricing__c newSP = new State_Pricing__c();
                        newSP.put('Item_Update__c', record.Id);
                        newSP.Locked__c = true;
                        newSP.RecordTypeId=recordTypeId;
                        newSP.State__c = 'NY';
                        newSP.Start_Date__c = Date.newInstance(1990, 01, 01);
                        newSP.End_Date__c = System.today() + 7305;
                        newSP.State_Adjustment__c	= 0;
                        newSP.Old_State_Adjustment__c = 0;
                        statePricingRecordsToCopy.add(newSP);
                    }
                    if (!hasNJState){
                        State_Pricing__c newSP = new State_Pricing__c();
                        newSP.put('Item_Update__c', record.Id);
                        newSP.Locked__c = true;
                        newSP.RecordTypeId=recordTypeId;
                        newSP.State__c = 'NJ';
                        newSP.Start_Date__c = Date.newInstance(1990, 01, 01);
                        newSP.End_Date__c = System.today() + 7305;
                        newSP.State_Adjustment__c	= 0;
                        newSP.Old_State_Adjustment__c = 0;
                        statePricingRecordsToCopy.add(newSP);
                    }
                    
                }
            }
        }
            

        List<String> itemUpdateRecordsToBlankTheirItemValue = new List<String>();

        for(Item_Update__c record : recordsList)
        {
            if(iuTypesToRemoveLookup.contains(record.IU_Type__c))
                itemUpdateRecordsToBlankTheirItemValue.add(record.Id);
        }

        if(statePricingRecordsToCopy.size() > 0)
            insert statePricingRecordsToCopy;

        if(itemUpdateRecordsToBlankTheirItemValue.size() > 0)
            setItemValueToBlank(itemUpdateRecordsToBlankTheirItemValue);
    }


    @future
    private static void setItemValueToBlank(List<String> recordIds)
    {
       /* System.debug('ItemUpdate_Trigger_Handler::setItemValueToBlank: method invoked...');
        List<Item_Update__c> recordsToProcess = [SELECT Id, Name FROM Item_Update__c WHERE Id IN : recordIds];

        for(Item_Update__c record : recordsToProcess)
        {
            record.Item__c = null;
        }

        update recordsToProcess;*/
    }



    /*******************************************************************************
    * Method name: approvalActions                                                 *
    * Description:                                                                 *
    *   Executes the corresponding actions based on the IU Type value:             *
    *                                                                              *
    *   Group A:                                                                   *
    *     Item Update (Copy):                                                      *
    *       -Updates field values from the Item Update back to the former Item     *
    *       -Links the existing attached files to the former Item records          *
    *       -Updates former states with values from the cloned states              *
    *       -Creates new states and relates them to the former Items               *
    *       -Removes the Active_Item_Update__c from the Item Active record         *
    *                                                                              *
    *   Group B:                                                                   *
    *     New Item / Vintage (Copy)                                                *
    *     Winery Unfinished Item (Copy):                                           *
    *       -Creates a new Item record with the field values from the Item Update  *
    *       -Creates new states based on the Item Update states records            *
    *       -Links the existing attached files to the new Item records             *
    *                                                                              *
    *******************************************************************************/
    public static void approvalActionsForItemUpdates(Map<Id, Item_Update__c> recordsNewMap, Map<Id, Item_Update__c> recordsOldMap)
    {
        System.debug('ItemUpdate_Trigger_Handler::approvalActionsForItemUpdates: method invoked... checking if conditions apply');
        System.debug('ItemUpdate_Trigger_Handler::approvalActionsForItemUpdates: newMap: ' + recordsNewMap);
        System.debug('ItemUpdate_Trigger_Handler::approvalActionsForItemUpdates: oldMap: ' + recordsOldMap);

        Map<Id, Item_Update__c> recordsToProcess_A = new Map<Id, Item_Update__c>();
        Map<Id, Item_Update__c> recordsToProcess_B = new Map<Id, Item_Update__c>();

        for(Item_Update__c record : recordsNewMap.values())
        {
            //Checkingconditions for items update records of type defined in group A
            if(record.IU_Type__c == 'Item Update (Copy)' && record.Approval_Status__c == 'Completed - Record Locked' && recordsOldMap.get(record.Id).Approval_Status__c != 'Completed - Record Locked')
            {
                recordsToProcess_A.put(record.Id, record);
            }
            //Checkingconditions for items update records of type defined in group B
            else if((record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'Winery Unfinished Item (Copy)' || record.IU_Type__c == 'New Item' || record.IU_Type__c == 'Winery Unfinished Item') && record.Approval_Status__c == 'Completed - Record Locked' && recordsOldMap.get(record.Id).Approval_Status__c != 'Completed - Record Locked')
            {
                recordsToProcess_B.put(record.Id, record);
            }
        }

        //Actions for block A
        if(recordsToProcess_A.size() > 0)
        {
            //Update field values from the Item Update back to the former Item
            updateItemFieldValues(recordsToProcess_A);

            //Link the existing attached files to the former Item records
            linkAttachedFiles(recordsToProcess_A);

            //Update former states with values from the cloned states
            updateFormerStates(recordsToProcess_A);

            //Create new states with values from the cloned states
            createNewStates(recordsToProcess_A);

            //Remove the Active_Item_Update__c value from the Item Active record
            removeCurrentIipUpdateValue(recordsToProcess_A);
        }

        //Actions for block B
        if(recordsToProcess_B.size() > 0)
        {
           //Create new Item records with the field values from the Item Update records
           //This method's code also does:
           //   Creates new states based on the Item Update states records
           //   Links the existing attached files to the new Item records
           createNewItemRecords(recordsToProcess_B);
        }
    }



    private static void createNewItemRecords(Map<Id, Item_Update__c> records)
    {
        System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord: method invoked...');

        Map<String, Item__c> itemsToCreate = new Map<String, Item__c>();

        for(Item_Update__c record : records.values())
        {
            Item__c tmp = new Item__c();
            tmp.Converted_From__c = record.Id;

            if(record.IU_Type__c == 'New Item / Vintage (Copy)' || record.IU_Type__c == 'New Item' || record.IU_Type__c == 'Winery Unfinished Item')
            {
                for(Fields_New_Item_Vintage_Copy_B__c element : Fields_New_Item_Vintage_Copy_B__c.getAll().values())
                {
                    tmp.put(element.Item_Active_field_API_name__c, record.get(element.Name));
                }
            }
            else if(record.IU_Type__c == 'Winery Unfinished Item (Copy)')
            {
                for(Fields_Winery_Unfinished_Item_Copy_B__c element : Fields_Winery_Unfinished_Item_Copy_B__c.getAll().values())
                {
                    tmp.put(element.Item_Active_field_API_name__c, record.get(element.Name));
                }
            }

            itemsToCreate.put(record.Id, tmp);
        }

        if(itemsToCreate.size() > 0)
        {
            insert itemsToCreate.values();

            for(String itemUpdateId : itemsToCreate.keySet())
            {
                System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord::Create new states: Item Update Id: ' + itemUpdateId + ', New Item: ' + itemsToCreate.get(itemUpdateId));
            }


            //////////////////////
            //Creates new states based on the Item Update states records
            //////////////////////
            String stringIdsItemToCopy = '';
            for(Item_Update__c record : records.values())
            {
                stringIdsItemToCopy += '\'' + record.Id + '\', ';
            }
            if(stringIdsItemToCopy.endsWith(', '))
                stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');


            String queryStatesPricing = 'SELECT Id, Item__c, Item_Update__c';

            for(Fields_State_pricing_B__c element : Fields_State_pricing_B__c.getAll().values())
            {
                queryStatesPricing += ', ' + element.Name;
            }

            queryStatesPricing += ' FROM State_Pricing__c WHERE Item_Update__c IN (' + stringIdsItemToCopy + ')';
            System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord::Create new states: states to be cloned for the new Items queryStatesPricing: ' + queryStatesPricing);

            Map<String, List<State_Pricing__c>> statePricingsMap = new Map<String, List<State_Pricing__c>>();

            for(SObject record : Database.query(queryStatesPricing))
            {
                State_Pricing__c tmp = (State_Pricing__c)record;

                if(!statePricingsMap.containsKey(tmp.Item_Update__c))
                {
                    statePricingsMap.put(tmp.Item_Update__c, new List<State_Pricing__c>{tmp});
                }
                else
                {
                    statePricingsMap.get(tmp.Item_Update__c).add(tmp);
                }
            }

            System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord:::Create new states statePricingsMap: ' + statePricingsMap);

            List<SObject> statePricingRecordsToCreate = new List<SObject>();

            for(String itemUpdateId : itemsToCreate.keySet())
            {
                if(statePricingsMap.containsKey(itemUpdateId))
                {
                    System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord::Create new states: No. of State Pricing records to create from the existing item update with ID ' + itemUpdateId + ': '+ statePricingsMap.get(itemUpdateId).size());


                    for(State_Pricing__c sp : statePricingsMap.get(itemUpdateId))
                    {
                        State_Pricing__c newSP = new State_Pricing__c();
                        newSP.put('Item__c', itemsToCreate.get(itemUpdateId).Id);

                        for(Fields_State_pricing_B__c element : Fields_State_pricing_B__c.getAll().values())
                        {
                            newSP.put(element.Target_field_API_name__c, sp.get(element.Name));
                        }

                        statePricingRecordsToCreate.add(newSP);
                    }
                }
            }

            System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord::Create new states: No. of State Pricing records to create from new list: ' + statePricingRecordsToCreate.size());
            System.debug('ItemUpdate_Trigger_Handler::createNewItemRecord::Create new states: statePricingRecordsToCreate: ' + statePricingRecordsToCreate);

            if(statePricingRecordsToCreate.size() > 0)
                insert statePricingRecordsToCreate;




            //////////////////////
            //Links the existing attached files to the new Item records
            //////////////////////
            List<Item_Files__c> fileRecordsToProcess = new List<Item_Files__c>();

            for(Item_Files__c itemFile : [SELECT Id, Parent__c, Item_Active__c FROM Item_Files__c WHERE Parent__c IN : itemsToCreate.keySet()])
            {
                itemFile.Item_Active__c = itemsToCreate.get(itemFile.Parent__c).Id;
                fileRecordsToProcess.add(itemFile);
            }

            if(fileRecordsToProcess.size() > 0)
                update fileRecordsToProcess;
        }
            
    }


    private static void updateItemFieldValues(Map<Id, Item_Update__c> records)
    {
        System.debug('ItemUpdate_Trigger_Handler::updateItemFieldValues: method invoked...');

        String stringIdsItemToCopy = '';
        for(Item_Update__c record : records.values())
        {
            stringIdsItemToCopy += '\'' + record.Item__c + '\', ';
        }
        if(stringIdsItemToCopy.endsWith(', '))
            stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');

        String queryItemUpdateCopy = 'SELECT Id';

        for(Fields_Item_Update_Copy_B__c element : Fields_Item_Update_Copy_B__c.getAll().values())
        {
            queryItemUpdateCopy += ', ' + element.Name;
        }

        queryItemUpdateCopy += ' FROM Item__c WHERE Id IN (' + stringIdsItemToCopy + ')';
        System.debug('ItemUpdate_Trigger_Handler::updateItemFieldValues: queryItemUpdateCopy: ' + queryItemUpdateCopy);


        Map<Id, Item__c> itemsMap = new Map<Id, Item__c>();

        for(SObject record : Database.query(queryItemUpdateCopy))
        {
            itemsMap.put(record.Id, (Item__c)record);
        }

        List<Item__c> itemsToUpdate = new List<Item__c>();

        for(Item_Update__c record : records.values())
        {
            Item__c tmp = itemsMap.get(record.Item__c);
            tmp.Converted_From__c = record.Id;

            for(Fields_Item_Update_Copy_B__c element : Fields_Item_Update_Copy_B__c.getAll().values())
            {
                tmp.put(element.Item_Active_field_API_name__c, record.get(element.Name));
            }

            itemsToUpdate.add(tmp);
        }

        if(itemsToUpdate.size() > 0)
            update itemsToUpdate;
    }


    private static void linkAttachedFiles(Map<Id, Item_Update__c> records)
    {
        List<Item_Files__c> recordsToProcess = new List<Item_Files__c>();

        for(Item_Files__c itemFile : [SELECT Id, Parent__c, Item_Active__c FROM Item_Files__c WHERE Parent__c IN : records.keySet()])
        {
            itemFile.Item_Active__c = records.get(itemFile.Parent__c).Item__c;
            recordsToProcess.add(itemFile);
        }

        if(recordsToProcess.size() > 0)
            update recordsToProcess;
    }

    private static void updateFormerStates(Map<Id, Item_Update__c> records)
    {
        System.debug('ItemUpdate_Trigger_Handler::updateFormerStates: method invoked...');

        String stringIdsItemToCopy = '';
        for(Item_Update__c record : records.values())
        {
            stringIdsItemToCopy += '\'' + record.Id + '\', ';
        }
        if(stringIdsItemToCopy.endsWith(', '))
            stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');


        String queryStatesPricing = 'SELECT Id, Item__c, Trigger_Lookup__c';

        for(Fields_State_pricing_B__c element : Fields_State_pricing_B__c.getAll().values())
        {
            queryStatesPricing += ', ' + element.Name;
        }

        queryStatesPricing += ' FROM State_Pricing__c WHERE Trigger_Lookup__c != NULL AND Item_Update__c IN (' + stringIdsItemToCopy + ')';
        System.debug('ItemUpdate_Trigger_Handler::updateFormerStates: queryStatesPricing: ' + queryStatesPricing);

        List<SObject> statePricingRecordsToUpdate = new List<SObject>();
        Schema.SObjectType sobjToken = Schema.getGlobalDescribe().get('State_Pricing__c');

        System.debug('ItemUpdate_Trigger_Handler::updateFormerStates: No. of State Pricing records to update from query: ' + Database.query(queryStatesPricing).size());

        for(SObject record : Database.query(queryStatesPricing))
        {
            State_Pricing__c tmp = (State_Pricing__c)record;

            SObject sobj = sobjToken.newSObject(tmp.Trigger_Lookup__c);

            for(Fields_State_pricing_B__c element : Fields_State_pricing_B__c.getAll().values())
            {
                sobj.put(element.Target_field_API_name__c, record.get(element.Name));
            }

            statePricingRecordsToUpdate.add(sobj);
        }

        System.debug('ItemUpdate_Trigger_Handler::updateFormerStates: No. of State Pricing records to update from new list: ' + statePricingRecordsToUpdate.size());
        System.debug('ItemUpdate_Trigger_Handler::updateFormerStates: statePricingRecordsToUpdate: ' + statePricingRecordsToUpdate);

        if(statePricingRecordsToUpdate.size() > 0)
            update statePricingRecordsToUpdate;
    }


    private static void createNewStates(Map<Id, Item_Update__c> records)
    {
        System.debug('ItemUpdate_Trigger_Handler::createNewStates: method invoked...');

        String stringIdsItemToCopy = '';
        for(Item_Update__c record : records.values())
        {
            stringIdsItemToCopy += '\'' + record.Id + '\', ';
        }
        if(stringIdsItemToCopy.endsWith(', '))
            stringIdsItemToCopy = stringIdsItemToCopy.removeEnd(', ');


        String queryStatesPricing = 'SELECT Id, Item__c, Item_Update__c';

        for(Fields_State_pricing_A__c element : Fields_State_pricing_A__c.getAll().values())
        {
            queryStatesPricing += ', ' + element.Name;
        }

        queryStatesPricing += ' FROM State_Pricing__c WHERE Trigger_Lookup__c = NULL AND Item_Update__c IN (' + stringIdsItemToCopy + ')';
        System.debug('ItemUpdate_Trigger_Handler::createNewStates: queryStatesPricing: ' + queryStatesPricing);

        Map<String, List<State_Pricing__c>> statePricingsMap = new Map<String, List<State_Pricing__c>>();

        for(SObject record : Database.query(queryStatesPricing))
        {
            State_Pricing__c tmp = (State_Pricing__c)record;

            if(!statePricingsMap.containsKey(tmp.Item_Update__c))
            {
                statePricingsMap.put(tmp.Item_Update__c, new List<State_Pricing__c>{tmp});
            }
            else
            {
                statePricingsMap.get(tmp.Item_Update__c).add(tmp);
            }
        }

        System.debug('ItemUpdate_Trigger_Handler::createNewStates: statePricingsMap: ' + statePricingsMap);

        List<SObject> statePricingRecordsToCreate = new List<SObject>();

        for(Item_Update__c itemUpdate : records.values())
        {
            if(statePricingsMap.containsKey(itemUpdate.Id))
            {
                System.debug('ItemUpdate_Trigger_Handler::createNewStates: No. of State Pricing records to create for item update with ID ' + itemUpdate.Id + ': '+ statePricingsMap.get(itemUpdate.Id).size());


                for(State_Pricing__c sp : statePricingsMap.get(itemUpdate.Id))
                {
                    State_Pricing__c newSP = new State_Pricing__c();
                    newSP.put('Item__c', itemUpdate.Item__c);

                    for(Fields_State_pricing_A__c element : Fields_State_pricing_A__c.getAll().values())
                    {
                        newSP.put(element.Target_field_API_name__c, sp.get(element.Name));
                    }

                    statePricingRecordsToCreate.add(newSP);
                }
            }
        }

        System.debug('ItemUpdate_Trigger_Handler::createNewStates: No. of State Pricing records to create from new list: ' + statePricingRecordsToCreate.size());
        System.debug('ItemUpdate_Trigger_Handler::createNewStates: statePricingRecordsToCreate: ' + statePricingRecordsToCreate);

        if(statePricingRecordsToCreate.size() > 0)
            insert statePricingRecordsToCreate;
    }


    private static void removeCurrentIipUpdateValue(Map<Id, Item_Update__c> records)
    {
        List<String> itemsActiveIds = new List<String>();

        for(Item_Update__c record : records.values())
        {
            itemsActiveIds.add(record.Item__c);
        }

        if(itemsActiveIds.size() > 0)
        {
            List<Item__c> itemsActiveToUpdate = [SELECT Id, Active_Item_Update__c FROM Item__c WHERE Id IN : itemsActiveIds];

            for(Item__c itemActive : itemsActiveToUpdate)
            {
                itemActive.Active_Item_Update__c = null;
            }

            update itemsActiveToUpdate;
        }
    }
    
     public static void updateUpchargevlaues(List<Item_Update__c> Itemlist){  
        system.debug('Itemlist------'+Itemlist);
        
        //For CIF
        List<CIF_Upcharge_Reference_Table__c> cifr = [select id,name,CIFUpcharge__c,CountryID__c,ItemPackID__c,ItemSizeID__c
                                                    from CIF_Upcharge_Reference_Table__c];
        //For Warehouse                                            
        List<Warehouse_Upcharge_Reference_Table__c> wurList = [select id,name,Whse_Upcharge__c,CountryID__c,Pack__c,Size__c, Bev_Code__c
                                                    from Warehouse_Upcharge_Reference_Table__c];                                            
        
        //For CIF
        Map<string,Decimal> getUpchargemapval = new Map<string,Decimal>();
        
        for(CIF_Upcharge_Reference_Table__c ref : cifr){
            String countryItemSize = ref.CountryID__c+','+ref.ItemPackID__c+','+ref.ItemSizeID__c;
            system.debug('countryItemSize------'+countryItemSize);
            getUpchargemapval.put(countryItemSize,ref.CIFUpcharge__c);
            
        }
        
        //For Warehouse
        Map<string,Decimal> getwhUpchargemapval = new Map<string,Decimal>();
        
        for(Warehouse_Upcharge_Reference_Table__c ref : wurList){
            String whsecountryItemSize = ref.CountryID__c+','+ref.Pack__c+','+ref.Size__c+','+ref.Bev_Code__c;
            getwhUpchargemapval.put(whsecountryItemSize,ref.Whse_Upcharge__c);
            
        }
                
        for(Item_Update__c IU : Itemlist){
            string itemCountryCode= IU.Country_Code_Lookup__c+','+IU.Base_Units_per_Case__c+','+IU.Size__c+','+IU.Beverage_Code__c;
            string itemCountryCodeCif= IU.Country_Code_Lookup__c+','+IU.Base_Units_per_Case__c+','+IU.Size__c;
            IU.IIP_CIF_Upcharge__c= getUpchargemapval.get(itemCountryCodeCif);
            IU.IIP_Warehouse_Upcharge__c = getwhUpchargemapval.get(itemCountryCode);
        }
        ItemUpdate_Trigger_Handler.isCFICalculation  = false;
    }
}