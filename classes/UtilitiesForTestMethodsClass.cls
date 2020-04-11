/************************************************************************************************************
* Class Name       : UtilitiesForTestMethodsClass
* Version          : 1.0
* Created Date     : 18/01/2017
* Description      : This class helps on test methods creation so that when SFDC model changes the only place
*                  : that needs to be changed is this class instead of every test method
* Modification Log :
* Developer name                 Date                       Description
* ----------------------------------------------------------------------------------------------------------
* Jonathan Major                18/01/2017                Initial version
------------------------------------------------------------------------------------------------------------
************************************************************************************************************/
@isTest
public without sharing class UtilitiesForTestMethodsClass
{
    public static List<sObject> getCustomSetting()
    {   
        List<sObject> listSObjects = new List<sObject>();

        Fields_Item_Update_Copy_A__c setting1 = new Fields_Item_Update_Copy_A__c();
        setting1.Name = 'Aging__c';
        setting1.Item_In_Process_field_API_name__c = 'Aging__c';
        listSObjects.add(setting1);

        Fields_New_Item_Vintage_Copy_A__c setting2 = new Fields_New_Item_Vintage_Copy_A__c();
        setting2.Name = 'Aging__c';
        setting2.Item_In_Process_field_API_name__c = 'Aging__c';
        listSObjects.add(setting2);

        Fields_Winery_Unfinished_Item_Copy_A__c setting3 = new Fields_Winery_Unfinished_Item_Copy_A__c();
        setting3.Name = 'Aging__c';
        setting3.Item_In_Process_field_API_name__c = 'Aging__c';
        listSObjects.add(setting3);

        Fields_State_pricing_A__c setting4 = new Fields_State_pricing_A__c();
        setting4.Name = 'State__c';
        setting4.Target_field_API_name__c   = 'State__c';
        listSObjects.add(setting4);

        Fields_New_Item_Vintage_Copy_B__c setting5 = new Fields_New_Item_Vintage_Copy_B__c();
        setting5.Name = 'Aging__c';
        setting5.Item_Active_field_API_name__c = 'Aging__c';
        listSObjects.add(setting5);

        Fields_State_pricing_B__c  setting6 = new Fields_State_pricing_B__c ();
        setting6.Name = 'State_Adjustment__c';
        setting6.Target_field_API_name__c = 'State_Adjustment__c';
        listSObjects.add(setting6);

        IU_types_to_remove_lookup__c setting7 = new IU_types_to_remove_lookup__c();
        setting7.Name = 'New Item / Vintage (Copy)';
        listSObjects.add(setting7);

        Fields_Item_Update_Copy_B__c  setting8 = new Fields_Item_Update_Copy_B__c();
        setting8.Name = 'Add_State_Adjustment__c';
        setting8.Item_Active_field_API_name__c = 'Add_State_Adjustment__c';
        listSObjects.add(setting8);

        insert listSObjects;

        return listSObjects;
    }

    public static Item__c getItemNew()
    {
        Item__c itemNew = new Item__c(
                Name = 'Item - Active TEST',
                Marketing_Product_Name__c='test',
                Base_Units_per_Case__c = '12');
        insert itemNew;
        return itemNew;
    }

    public static State_Pricing__c getStatePricing(String itemNewId)
    {
        State_Pricing__c statePricing = new State_Pricing__c(Item__c = itemNewId);
        insert statePricing;
        return statePricing;
    }

    public static Item_Update__c getItemUpdate(String ui_type, Id itemNewId)
    {
        Item_Update__c itemUpdate = new Item_Update__c(
                IU_Type__c = ui_type,
                Item__c = itemNewId,
                Base_Units_per_Case__c = '12'
        );
        itemUpdate.Marketing_Product_Name__c='test';
        //insert itemUpdate;
        return itemUpdate;
    }

    public static User getUser(String userName)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'xyz123', Email='test@test.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=userName);
        insert u;
        return u;
    }

    public static Item_Files__c getItemFile(Id itemUpdateParent)
    {
        Item_Files__c itemFile = new Item_Files__c(Parent__c = itemUpdateParent, Document_Type__c = 'Other');
        insert itemFile;
        return itemFile;
    }

    public static Brand__c getBrand()
    {
        Brand__c brand = new Brand__c(Name = 'Brand Test', Brand_Code_Marketing__c = 'GAJ', Marketing_Manager__c = getUser('silverlinesucks@neverhireusagain.new').Id, Marketing_Executive__c = getUser('silverlinesucks@neverhireusagain.org').Id);
        insert brand;
        return brand;
    }

    public static HFT__Field_Tracker_Preferences__c getFieldTrackerPreferences()
    {
        HFT__Field_Tracker_Preferences__c fieldTrackerPreferences = new HFT__Field_Tracker_Preferences__c(HFT__Object_Name__c = 'Item_Update__c', HFT__Selected_Fields__c = 'Last Name');
        insert fieldTrackerPreferences;
        return fieldTrackerPreferences;
    }

    public static HFT__Field_Histories__c getFieldHistory()
    {
        Item__c itemNew = getItemNew();
        Item_Update__c itemUpdate = getItemUpdate('Item Update (Copy)', itemNew.Id);
        insert itemUpdate;

        HFT__Field_Histories__c fieldHistory = new HFT__Field_Histories__c(
                                                                              HFT__HFT_Preferences__c = getFieldTrackerPreferences().Id,
                                                                              Item__c = itemNew.Id,
                                                                              Item_Update__c = itemUpdate.Id, 
                                                                              HFT__Object_Name__c = 'Item_Update__c'
                                                                          );
        insert fieldHistory;
        System.debug('fieldHistory: ' + fieldHistory);
        return fieldHistory;
    }
}