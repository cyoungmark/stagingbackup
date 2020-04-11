/***********************************************************************************************************
* Apex trigger name    : ItemUpdate
* Version              : 1.0
* Created Date         : 12/12/2017
* Description          : Trigger for the Item_Update__c object.
*                           Trigger functionality is declared in "ItemUpdate_Trigger_Handler" class
* Modification Log     :
* Developer name                 Date          Description
------------------------------------------------------------------------------------------------------------
* Jonathan Major                 12/12/2017    Initial version
* Diwaker Beesa                  08/30/2018    revision version
------------------------------------------------------------------------------------------------------------
***********************************************************************************************************/

trigger ItemUpdate on Item_Update__c (before insert, before update, after insert, after update)
{
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            ItemUpdate_Trigger_Handler.autopupulateFields(Trigger.new);
            if(ItemUpdate_Trigger_Handler.isCFICalculation)
            {
                ItemUpdate_Trigger_Handler.updateUpchargevlaues(Trigger.new);
            }
        }
        // Used to call HexaFieldTracker (managed package) so that selected fields can be tracked / create custom field history records.
        if(trigger.isUpdate){
           if(ItemUpdate_Trigger_Handler.isCFICalculation)
           {
             ItemUpdate_Trigger_Handler.updateUpchargevlaues(Trigger.new);
           }
             HFT.HexaFieldTrackerUtils.createFieldHistory(trigger.new, trigger.oldMap, false, true);
             
        }
        
    system.debug('updating');
        try{

            List <String> countryOfOrigins = new List <String>();
            List <String> brandCodes = new List <String>();
            List <String> bevarageCodes = new List <String>();
            List <String> TransferWhscodes= new List <String>();
            
            Map <String,Transfer_Cost_Table__c> transfersWhs = new Map <String,Transfer_Cost_Table__c>();
            Map <String,Inbound_Freight_Table__c> ifts = new Map <String,Inbound_Freight_Table__c>();
            Map <String,Marine_Insurance_Table__c> marines = new Map <String,Marine_Insurance_Table__c>();
            Map <String,Harbor_Maint_Tables__c> harbors = new Map <String,Harbor_Maint_Tables__c>();
            Map <String,Duty_Table__c> duties = new Map <String,Duty_Table__c>();
            Map <String,Excise_Tax_Table__c> excisetaxes= new Map <String,Excise_Tax_Table__c>();
            
            for (Item_Update__c obj: trigger.new){
                countryOfOrigins.add(obj.Country_of_Origin__c.toLowerCase());
                brandCodes.add(obj.Brand_Code_Marketing__c );
                bevarageCodes.add(obj.Beverage_Code__c);
                TransferWhscodes.add(obj.Branches__c.split('\\|')[0]);
            }
            

            for (Transfer_Cost_Table__c t : [select TCT_Case_Transfer_Cost__c,TCT_Transfer_Whs__c from Transfer_Cost_Table__c where TCT_Transfer_Whs__c in:TransferWhscodes Order By TCT_Case_Transfer_Cost__c ASC]) {
                transfersWhs.put(t.TCT_Transfer_Whs__c,t);
            }
            //system.debug(transfersWhs);
            for (Inbound_Freight_Table__c i : [select IFT_X20_Insulation__c, IFT_X20_Ocean_Freight__c, IFT_X40_Inland_Freight__c,IFT_X40_Inland_Fuel_SurCharge__c,IFT_X40_Ocean_Freight__c,
                    IFT_X40_BAF__c, IFT_X20_BAF__c,IFT_X40_Insulation__c,IFT_X40_Refer__c, IFT_ISPS__c, IFT_BOL_Charge__c,
                    IFT_Manifest_Documentation__c,IFT_Country_of_Origin_Name__c from Inbound_Freight_Table__c where IFT_Country_of_Origin_Name__c in: countryOfOrigins]) {
                ifts.put(i.IFT_Country_of_Origin_Name__c.toLowerCase(),i);
            }
            for (Marine_Insurance_Table__c m : [select MIT_Weighted_Average_Price__c,MIT_Brand_Code__c  from Marine_Insurance_Table__c where MIT_Brand_Code__c in: brandCodes]) {
                marines.put(m.MIT_Brand_Code__c,m);
            }
            for (Harbor_Maint_Tables__c h : [select HMT_Harbor_Mant_Fee_Per_Case__c,HMT_Brand_Code__c  from Harbor_Maint_Tables__c where HMT_Brand_Code__c in: brandCodes]) {
                harbors.put(h.HMT_Brand_Code__c,h);
            }
            for (Duty_Table__c d : [select DT_Duty_Per_Liter__c,DT_Beverage_Code__c from Duty_Table__c where DT_Beverage_Code__c in: bevarageCodes]) {
                duties.put(d.DT_Beverage_Code__c,d);
            }
            for (Excise_Tax_Table__c et : [select ETT_Excise_Tax_Rate_Per_Liter__c,ETT_Beverage_Code__c,ETT_Excise_Tax_Rate_Per_Gallon__c from Excise_Tax_Table__c where ETT_Beverage_Code__c in: bevarageCodes]) {
                excisetaxes.put(et.ETT_Beverage_Code__c,et);
            }

            
            List <Item_In_Process_Formulas__c> IIP_Formulas = new List <Item_In_Process_Formulas__c>();
            IIP_Formulas = [select Name__c, formula__c,Overwrite_Non_Empty_Values__c from Item_In_Process_Formulas__c limit 1000];
            
            
            
            for (Item_Update__c obj: trigger.new){
                Inbound_Freight_Table__c ift = null;
                Marine_Insurance_Table__c marine = null;
                Harbor_Maint_Tables__c harbor = null;
                Duty_Table__c duty= null;
                Transfer_Cost_Table__c transferWhs = null;
                Excise_Tax_Table__c exciseTax = null;
                try {
                    
                    ift = ifts.get(obj.Country_of_Origin__c.toLowerCase());/*
                    [select IFT_X40_Inland_Freight__c,IFT_X40_Inland_Fuel_SurCharge__c,IFT_X40_Ocean_Freight__c,
                    IFT_X40_BAF__c, IFT_X20_BAF__c,IFT_X40_Insulation__c,IFT_X40_Refer__c, IFT_ISPS__c, IFT_BOL_Charge__c,
                    IFT_Manifest_Documentation__c from Inbound_Freight_Table__c where IFT_Country_of_Origin_Name__c=:obj.Country_of_Origin__c limit 1];
                */
                } catch(exception e){system.debug(e);}
                try {
                    marine = marines.get(obj.Brand_Code_Marketing__c);
                    //[select MIT_Weighted_Average_Price__c from Marine_Insurance_Table__c where MIT_Brand_Code__c=:obj.Brand_Code_Marketing__c limit 1];
                } catch(exception e){}
                try {
                    harbor = harbors.get(obj.Brand_Code_Marketing__c);
                    //[select HMT_Harbor_Mant_Fee_Per_Case__c from Harbor_Maint_Tables__c where HMT_Brand_Code__c=:obj.Brand_Code_Marketing__c limit 1];
                } catch(exception e){}
                try {
                    duty = duties.get(obj.Beverage_Code__c);
                    //[select DT_Duty_Per_Liter__c from Duty_Table__c where DT_Beverage_Code__c=:obj.Beverage_Code__c limit 1];
                } catch(exception e){}
                try {
                    transferWhs = transfersWhs.get(obj.Branches__c.split('\\|')[0]);
                } catch(exception e){}
                try {
                    exciseTax = excisetaxes.get(obj.Beverage_Code__c);
                } catch(exception e){}
                
                for(Item_In_Process_Formulas__c formula: IIP_Formulas){
                    
                    try {
                    
                    String formulaStringTemp = formula.formula__c.deleteWhitespace();
                    
                    boolean isReturn=false;
                    
                    List <String> conds = formulaStringTemp.split('Else');
                    
                    for (String formulaString : conds){
                        if (!isReturn){
                    
                            String Condition = formulaString.substring(formulaString.indexOf('If(')+3,formulaString.indexOf(')Return'));
                            //system.debug(Condition);
    
                            String Result = formulaString.substring(formulaString.indexOf('Return(')+7,formulaString.length()-1 );
                            
                            //system.debug(Result);
                            integer j;
                            integer fieldsInResult = 0;
                            fieldsInResult  = Result.countMatches('Field(');
                            for (j=0;j<fieldsInResult ;j++){
                            
                                String field='';
                                field=Result.substring(Result.indexOf('Field(')+6,Result.indexOf(')'));
                                //system.debug(field);
                                if(field.contains('Inbound_Freight_Table__c.')){
                                    if (ift!=null){
                                        Result=Result.replaceFirst(field,String.valueOf(ift.get(field.replace('Inbound_Freight_Table__c.',''))).deleteWhitespace());
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                       
                                    }
                                } else if (field.contains('Marine_Insurance_Table__c.')){
                                    if (marine!=null){
                                        Result=Result.replaceFirst(field,String.valueOf(marine.get(field.replace('Marine_Insurance_Table__c.',''))).deleteWhitespace());
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                       
                                    }
                                } else if (field.contains('Harbor_Maint_Table__c.')){
                                    if (harbor!=null){
                                        Result=Result.replaceFirst(field,String.valueOf(harbor.get(field.replace('Harbor_Maint_Table__c.',''))).deleteWhitespace());
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                    }
                                } else if (field.contains('Duty_Table__c.')){
                                    if (duty!=null){
                                        Result=Result.replaceFirst(field,String.valueOf(duty.get(field.replace('Duty_Table__c.',''))).deleteWhitespace());
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                    }
                                } else if (field.contains('Transfer_Cost_Table__c.')){
                                    if (transferWhs!=null){
                                        try{
                                            Result=Result.replaceFirst(field,String.valueOf(transferWhs.get(field.replace('Transfer_Cost_Table__c.',''))).deleteWhitespace());
                                        } catch(exception e){}
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                    }
                                } else if (field.contains('Excise_Tax_Table__c.')){
                                    if (exciseTax!=null){
                                        Result=Result.replaceFirst(field,String.valueOf(exciseTax.get(field.replace('Excise_Tax_Table__c.',''))).deleteWhitespace());
                                    } else{
                                        if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                             Result=Result.replaceFirst(field,'0');
                                        } else {
                                            Result=Result.replaceFirst(field,'');
                                        }
                                    }
                                } else {
                                    if(obj.get(field)!=null){
                                        //system.debug(obj.get(field));
                                        Result=Result.replaceFirst(field,String.valueOf(obj.get(field)));
                                    } else {
                                        Result=Result.replaceFirst(field,'');
                                    }
                                }
                                Result=Result.replaceFirst('Field\\(','');
                                Result=Result.replaceFirst('\\)','');
                                //system.debug(Result);
                            }
                            
                            Decimal DecResult= null;
                            if (Result.contains('+')||Result.contains('-')||Result.contains('*')||Result.contains('/')){
                                DecResult = new RT_Expression(Result).eval();
                            }
                            //Decimal DecResult= null;
                            integer i;
    
                            integer fieldsInCondition = 0;
                            fieldsInCondition = Condition.countMatches('Field(');
                            for (i=0;i<fieldsInCondition;i++){
                                String field='';
                                //system.debug(Condition);
                                //system.debug(Condition.indexOf('Field('));
                                field=Condition.substring(Condition.indexOf('Field(')+6,Condition.indexOf(')'));
                                field=field.replaceAll('"','');
                                //system.debug(field);
                                /*if(field.contains('Inbound_Freight_Table__c.')){
                                    if (ift!=null){
                                        Condition=Condition.replaceFirst(field,String.valueOf(ift.get(field.replace('Inbound_Freight_Table__c.',''))).deleteWhitespace());
                                    } else {
                                        Condition=Condition.replaceFirst(field,'');
                                    }
                                } else if (field.contains('Marine_Insurance_Table__c.')){
                                    if (marine!=null){
                                        Condition=Condition.replaceFirst(field,String.valueOf(marine.get(field.replace('Marine_Insurance_Table__c.',''))).deleteWhitespace());
                                    } else {
                                        Condition=Condition.replaceFirst(field,'');
                                    }
                                } else if (field.contains('Harbor_Maint_Tables__c.')){
                                    if (harbor!=null){
                                        Condition=Condition.replaceFirst(field,String.valueOf(harbor.get(field.replace('Harbor_Maint_Tables__c.',''))).deleteWhitespace());
                                    } else {
                                        Condition=Condition.replaceFirst(field,'');
                                    }
                                } else if (field.contains('Duty_Table__c.')){
                                    if (duty!=null){
                                        Condition=Condition.replaceFirst(field,String.valueOf(duty.get(field.replace('Duty_Table__c.',''))).deleteWhitespace());
                                    } else {
                                        Condition=Condition.replaceFirst(field,'');
                                    }
                                } else if (field.contains('Transfer_Cost_Table__c.')){
                                   if (transferWhs!=null){
                                        try{
                                            Condition=Condition.replaceFirst(field,String.valueOf(transferWhs.get(field.replace('Transfer_Cost_Table__c.',''))).deleteWhitespace());
                                       }catch(exception e){}
                                    } else {
                                        Condition=Condition.replaceFirst(field,'');
                                    }
                                }  else {*/
                                if(obj.get(field)!=null){
                                    Condition=Condition.replaceFirst(field,String.valueOf(obj.get(field)).deleteWhitespace());
                                } else {
                                    Condition=Condition.replaceFirst(field,'');
                                }
                                //}
                                Condition=Condition.replaceFirst('Field\\(','');
                                Condition=Condition.replaceFirst('\\)','');
                                //system.debug(Condition);
                            }
                            
                            
                            if (Condition.substring(0, Condition.indexOf('(')) == 'Equals'){
                                Condition=Condition.replaceFirst('Equals\\(','');
                                Condition=Condition.replaceFirst('\\)','');
                                List <String> SValues = Condition.split(',');
                                if (SValues[0]==SValues[1] && (formula.Overwrite_Non_Empty_Values__c==true ||  obj.get(formula.name__c)==null || obj.get(formula.name__c)=='')){
                                    if(DecResult==null){
                                        try{
                                            obj.put(formula.name__c,Result);
                                        } catch(exception e){
                                            obj.put(formula.name__c,decimal.valueOf(Result)); 
                                        }
                                    } else {
                                        obj.put(formula.name__c,DecResult);
                                    }
                                isReturn=true;
                                }
                            } else if (Condition.substring(0, Condition.indexOf('(')) == 'IsNull'){
                                Condition=Condition.replaceFirst('IsNull\\(','');
                                Condition=Condition.replaceFirst('\\)','');
                                if (Condition=='' && (formula.Overwrite_Non_Empty_Values__c==true ||  obj.get(formula.name__c)==null || obj.get(formula.name__c)=='')){
                                    if(DecResult==null){
                                        try{
                                        obj.put(formula.name__c,Result);
                                        } catch(exception e){
                                            obj.put(formula.name__c,decimal.valueOf(Result)); 
                                        }
                                    } else {
                                        obj.put(formula.name__c,DecResult);
                                    }
                                isReturn=true;
                                }
                                
                            } else if (Condition.substring(0, Condition.indexOf('(')) == 'IsSubstring'){
                                Condition=Condition.replaceFirst('IsSubstring\\(','');
                                Condition=Condition.replaceFirst('\\)','');
                                List <String> SValues = Condition.split(',');
                                //system.debug(SValues);
                                if (SValues[0].countMatches(SValues[1])>0 && (formula.Overwrite_Non_Empty_Values__c==true ||  obj.get(formula.name__c)==null || obj.get(formula.name__c)=='')){
                                    if(DecResult==null){
                                        try{
                                        obj.put(formula.name__c,Result);
                                        } catch(exception e){
                                            obj.put(formula.name__c,decimal.valueOf(Result)); 
                                        }
                                    } else {
                                        obj.put(formula.name__c,DecResult);
                                    }
                                    isReturn=true;
                                }
                                
                                
                            } else if (Condition.substring(0, Condition.indexOf('(')) == 'Boolean'){
                                Condition=Condition.replaceFirst('Boolean\\(','');
                                Condition = Condition.removeEnd(')');
                                Decimal resultRT = null;
                                resultRT = new RT_Expression(Condition).eval();
                                
                                if (resultRT==1 && (formula.Overwrite_Non_Empty_Values__c==true ||  obj.get(formula.name__c)==null || obj.get(formula.name__c)=='')){
                                    if(DecResult==null){
                                       try{
                                        obj.put(formula.name__c,Result);
                                        } catch(exception e){
                                            obj.put(formula.name__c,decimal.valueOf(Result)); 
                                        }
                                    } else {
                                        obj.put(formula.name__c,DecResult);
                                    }
                                    isReturn=true;
                                }
                            } 
                        }
                    
                    }
                    
                //}
                } catch(exception e){system.debug('exception: ' + e + ' in formula' + formula);}
                }
            }
        } catch(exception e){system.debug('=-=-=--=' + e);}
    }

    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            // Used to call HexaFieldTracker (managed package) so that selected fields can be tracked / create custom field history records.
            HFT.HexaFieldTrackerUtils.createFieldHistory(trigger.new, trigger.oldMap, true, false);
            ItemUpdate_Trigger_Handler.copyStatePricingRecords(Trigger.new);
            ItemUpdate_Trigger_Handler.relateItemInProcessWithItemActive(Trigger.new);
        }

        if(Trigger.isUpdate)
        {
            if( UtilityTriggers.executedTriggers.contains('ItemUpdate_AfterUpdate'))
            {
              System.debug('ItemUpdate trigger already executed for the after update event... ignoring...');
              return;
            }
            else
            {
                ItemUpdate_Trigger_Handler.approvalActionsForItemUpdates(Trigger.newMap, Trigger.oldMap);
                UtilityTriggers.executedTriggers.add('ItemUpdate_AfterUpdate');
            }
        }
    }
}