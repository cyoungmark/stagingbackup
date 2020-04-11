@isTest
private class ItemUpdateTest {
  
    @isTest static void test() {
    
        

        List<Item_Update__c> listItemUpdate = new List<Item_Update__c>();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = [Select id from User where Id = :UserInfo.getUserId()];
        
        Brand__c brand = new Brand__c (name='test', Brand_Code_Marketing__c='tes',Marketing_Executive__c=u.id, Marketing_Manager__c= u.id);
        insert brand;
        
        Item__c itemNew = new Item__c(Name = 'Item - Active TEST');
        insert itemNew;
        
        Item_Update__c itemUpdate = new Item_Update__c(
                IU_Type__c = 'New Item / Vintage (Copy)',
                Item__c = itemNew.Id,
                Base_Units_per_Case__c = '12');
        
        Test.startTest();

        insert itemUpdate;
        
        List <Item_In_Process_Formulas__c> flist = new List <Item_In_Process_Formulas__c>();
        
        Item_In_Process_Formulas__c formula1 = new Item_In_Process_Formulas__c();
        formula1.name='test';
        formula1.Formula__c='If (IsSubstring (Field(Branches__c),2|PATERNO WINES INTERNATIONAL BS|00002|WH|0)) Return(0)Else If (IsSubstring (Field(Branches__c),18|TERLATO ARTISANS SPIRITS|00018|WH|0)) Return(0) Else If (Boolean (Field("Country_of_Origin__c")=="" || Field("Country_of_Origin__c")=="UNITED STATES")) Return(Field(Inbound_Freight_Table__c.IFT_X40_Insulation__c)/Field(Bottles_Per_Shipment__c)) Else If (Boolean (1==1)) Return(60/Field(Bottles_Per_Shipment__c))';
        formula1.Name__c='ci_cc_I1_Chassis__c';
        formula1.Overwrite_Non_Empty_Values__c=true;
        flist.add(formula1);
        
        Item_In_Process_Formulas__c formula2 = new Item_In_Process_Formulas__c();
        formula2.name='test';
        formula2.Formula__c='If (Boolean (Field("Brand_Code_Marketing__c")=="GAJ") Return(Field(Inbound_Freight_Table__c.IFT_X40_Insulation__c))Else If (Boolean ( Field("Country_of_Origin__c")=="") Return(0) Else If (Boolean ( Field("Country_of_Origin__c")=="ITALY") Return(Field(Inbound_Freight_Table__c.IFT_X40_Insulation__c)) Else If (Boolean (1==1)) Return(Field(Inbound_Freight_Table__c.IFT_X40_Insulation__c))';
        formula2.Name__c='ci_cc_F1_Insulation__c';
        formula2.Overwrite_Non_Empty_Values__c=true;
        flist.add(formula2);
        
        Item_In_Process_Formulas__c formula3 = new Item_In_Process_Formulas__c();
        formula3.name='test';
        formula3.Formula__c='If (Equals (Field(Container_Color__c),Brown)) Return(Green)';
        formula3.Name__c='Container_Color__c';
        formula3.Overwrite_Non_Empty_Values__c=true;
        flist.add(formula3);
        
        Item_In_Process_Formulas__c formula4 = new Item_In_Process_Formulas__c();
        formula4.name='test';
        formula4.Formula__c='If (IsNull (Field(Container_Color__c))) Return(Blue)';
        formula4.Name__c='Container_Color__c';
        formula4.Overwrite_Non_Empty_Values__c=true;
        flist.add(formula4);
        Test.stopTest();
        insert flist;
        
        
        
        itemUpdate.Bottles_Per_Shipment__c=20;
        itemUpdate.Branches__c='236|CLEVELAND OH WAREHOUSE|00002|WH|0';
        update itemUpdate;
        
        Geography__c g = new Geography__c(name='test', Country_of_Origin__c='US');
        insert g;
        itemUpdate.Geography__c =g.Id;
        
        Inbound_Freight_Table__c ift = new Inbound_Freight_Table__c(name='test', IFT_Country_of_Origin_Name__c='US',IFT_X40_Inland_Freight__c=5);
        insert ift;
        update itemUpdate;
        
        delete flist;
        
        Item_In_Process_Formulas__c formula22 = new Item_In_Process_Formulas__c();
        formula22.name='test';
        formula22.Formula__c='If (IsNull (Field(Container_Color__c))) Return(Field(Marine_Insurance_Table__c.MIT_Weighted_Average_Price__c)/Field(Base_Units_per_Case__c))';
        formula22.Name__c='ci_cc_O1_Marine_Insurance__c';
        formula22.Overwrite_Non_Empty_Values__c=true;
        insert formula22;
        update itemUpdate;
        
        formula22.Formula__c='If (Boolean (1==1))Return(Field(Marine_Insurance_Table__c.MIT_Weighted_Average_Price__c))';
        update formula22;
        update itemUpdate;
        
 
        Marine_Insurance_Table__c m = new Marine_Insurance_Table__c (MIT_Brand_Code__c='tes',MIT_Weighted_Average_Price__c=5);
        insert m;
        itemUpdate.Brand__c =brand.Id;
        update itemUpdate;
        
        delete formula22;
        
        Item_In_Process_Formulas__c formula33 = new Item_In_Process_Formulas__c();
        formula33.name='test';
        formula33.Formula__c='If (Boolean (1==1)) Return(Field(Harbor_Maint_Table__c.HMT_Harbor_Mant_Fee_Per_Case__c)*0.00335/Field(Base_Units_per_Case__c))';
        formula33.Name__c='ci_cc_O1_Harbor_Fee__c';
        formula33.Overwrite_Non_Empty_Values__c=true;
        
        insert formula33;
        update itemUpdate;
        
        formula33.Formula__c='If (Boolean (1==1)) Return(Field(Harbor_Maint_Table__c.HMT_Harbor_Mant_Fee_Per_Case__c))';
        update formula33;
        update itemUpdate;
        
        Harbor_Maint_Tables__c h = new  Harbor_Maint_Tables__c (name='test',HMT_Brand_Code__c='tes');
        insert h;
        
        update itemUpdate;
        
        delete formula33;
        
        Item_In_Process_Formulas__c formula5 = new Item_In_Process_Formulas__c();
        formula5.name='test';
        formula5.Formula__c='If (Boolean (1==1)) Return(Field(Duty_Table__c.DT_Duty_Per_Liter__c)*Field(IIP_Standard_Cost_Ref_Liter_Per_Bottle__c))';
        formula5.Name__c='ci_cc_K1_Duty__c';
        formula5.Overwrite_Non_Empty_Values__c=true;
        
        insert formula5;
        update itemUpdate;
        
        formula5.Formula__c='If (Equals (Field(Container_Color__c),Brown)) Return(Field(Duty_Table__c.DT_Duty_Per_Liter__c)))';
        update formula5;
        update itemUpdate;
        
        
        
        Duty_Table__c d = new Duty_Table__c(name='test', DT_Beverage_Code__c='600');
        insert d;
        itemUpdate.Beverage_Code__c='600';
        update itemUpdate;
        delete formula5;
        
        Item_In_Process_Formulas__c formula6 = new Item_In_Process_Formulas__c();
        formula6.name='test';
        formula6.Formula__c='If (Boolean (1==1)) Return(Field(Transfer_Cost_Table__c.TCT_Case_Transfer_Cost__c)/Field(Base_Units_per_Case__c))';
        formula6.Name__c='X1_Freight__c';
        formula6.Overwrite_Non_Empty_Values__c=true;
        
        insert formula6;
        update itemUpdate;
        
        formula6.Formula__c='If (IsNull (Field(Container_Color__c))) Return(Field(Transfer_Cost_Table__c.TCT_Case_Transfer_Cost__c))';
        update formula6;
        update itemUpdate;
        
        Transfer_Cost_Table__c tr = new Transfer_Cost_Table__c (name='test',TCT_Transfer_Whs__c='236');
        insert tr;
        //update itemUpdate;
        
        
        
        
    }
    
}