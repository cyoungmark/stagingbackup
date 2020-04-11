public class SL_ctrl_DynTbl
{    
 
    public static String recordId;
    public static set<ID> setId = new set<ID>();
    
    @AuraEnabled
    public static String dynQry(String fldList, String objName, String sortFld, String sortDir, String queryFilter, 
                                String parentRecordId, String relationshipField, String parentField, Boolean filterByParent) {
        if(String.isBlank(sortDir) || (sortDir != 'ASC' && sortDir != 'DESC')){ 
            sortDir = 'ASC';
        }
        recordId=parentRecordId;
        String errMsg = '';
        String qStr = '';
        String[] fldArry = fldList.replaceAll(' ', '').split(',');
        String sortField = sortFld;
        
        //if(String.isBlank(sortField)) {
        //    sortField = fldArry[0];
        //}
    
        SL_FldObj[] fldMap = getFldMap(fldArry,objName);

        qStr += 'Select ';    
        String[] qryFldArry = new String[]{};
    
        for(SL_FldObj fm : fldMap) {
            // API and Name would be the same if field is 'Id'
            // due to how we handle Id field to display as a link
            if(String.isNotBlank(fm.fldType)) {
                if(fm.isRef && fm.lkupRelAPI != fm.lkupRelName) {
                    qryFldArry.add(fm.lkupRelAPI);
                    qryFldArry.add(fm.lkupRelName);
                
                    if(sortField == fm.apiName) {
                        sortField = fm.lkupRelName;
                    }
                }
                else {
                    qryFldArry.add(fm.apiName);

                }
            }
        }
    
        qStr += String.join(qryFldArry,',')+' ';
        qStr += 'From '+objName+ prepareWhereClause(queryFilter, parentRecordId, objName);
        
        if(filterByParent && String.isNotBlank(parentField)) {
            List<Sobject> lstTempList = Database.query('SELECT Id,' + parentField + ' FROM ' + Id.valueOf(parentRecordId).getSObjectType().getDescribe().getName() + ' WHERE ' + parentField + ' != NULL AND Id = \'' + parentRecordId + '\'');
            if(!lstTempList.isEmpty()) {
                Id parentId = (Id)lstTempList[0].get(parentField);
                qStr += qStr.contains(' WHERE ') 
                        ? ' AND ' + relationshipField + '=\'' + parentId + '\''
                        : ' WHERE ' + relationshipField + '=\'' + parentId + '\'';
            }
        }
        
        if(!filterByParent && String.isNotBlank(parentRecordId) && String.isNotBlank(relationshipField)) {
            qStr += qStr.contains(' WHERE ') 
                    ? ' AND ' + relationshipField + '=\'' + parentRecordId + '\''
                    : ' WHERE ' + relationshipField + '=\'' + parentRecordId + '\'';
        }
        if(String.isNotBlank(sortField)){
            qStr += ' ORDER BY ' + sortField + ' ' + sortDir;
            if(sortDir == 'ASC') {
                qStr += ' NULLS FIRST';
            } 
            else if(sortDir == 'DESC') {
                qStr += ' NULLS LAST';
            }
        }
        System.debug('Final query:: '+qStr);
        sObject[] recs = new sObject[]{};
        try {
            //qStr = 'Select Account__c,Account__r.Name From Knowledge__kav';
            recs = Database.query(qStr);
            System.debug('Final query result:: '+recs); 
        }
        catch(Exception e) {
            System.debug('ERROR:: '+e);
            errMsg = 'Please check field(s) and object API Names';
        }
        Schema.DescribeSObjectResult result = Schema.getGlobalDescribe().get(objName).getDescribe();
        String jsonRes = JSON.serialize(new SL_DynTblRes(recs,fldMap,sortDir,sortField,errMsg,result.isCreateable(),result.getName()));
    
        return jsonRes;
    }

    private static String handlePlaceHolderFields(String filtercriteria,String recordId,String objName){        
        if(recordId == null) 
            return filtercriteria;

        pattern myPattern = pattern.compile('<<([a-zA-Z0-9_]+)\\.([a-zA-Z0-9_]+)(__c)?>>');
        matcher myMatcher = myPattern.matcher(filtercriteria);
        if(!myMatcher.find()) 
            return filtercriteria;

        String expression;
        set<String> fields = new set<String>();
        set<String> sObjects = new set<String>();

        do
        {
            integer startIdx = myMatcher.start();
            integer endIdx = myMatcher.end();
            expression = filtercriteria.substring(startIdx, endIdx);
            
            integer IndexOfDot = expression.indexOf('.');
            integer IndexOfClose = expression.indexOf('>>');
            fields.add(expression.substring(IndexOfDot + 1, IndexOfClose));
            sObjects.add(expression.substring(2, IndexOfDot));
        }
        while(myMatcher.find());

        if(sObjects.size() > 1) 
            return filtercriteria;

        List<String> fieldsList = new List<String>();
        fieldsList.addAll(fields);
        String fieldsCS = String.join(fieldsList, ',');

        for(String obj : sObjects)
        {           
            sObject record =  Database.query('SELECT ' + fieldsCS + ' FROM ' +  obj + 
                                                ' WHERE Id=\'' + recordId + '\' LIMIT 1');
            for(String field : fields)
            {
                String exprToReplace = '<<' + obj + '.' + field + '>>';
                String replacingVal = '\''+ (String)record.get(field) + '\'';
                filtercriteria = filtercriteria.replaceFirst(exprToReplace, replacingVal);
            }            
            break;
        }        
        return filtercriteria;
    }
  
    private static String prepareWhereClause(String strFilterCriteria,String recordId,String objName) {
        if(String.isNotBlank(strFilterCriteria)) {
            strFilterCriteria = strFilterCriteria.trim();

            /*Handle place holder fields - Start*/
            strFilterCriteria = handlePlaceHolderFields(strFilterCriteria, recordId, objName);
            /*andle place holder fields - Stop*/

            List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserid()];
            
            //Supporting CurrentUser in filtercriteria
            while(strFilterCriteria.containsIgnoreCase('currentuser')) {
                Integer index = strFilterCriteria.indexOfIgnoreCase('currentuser');
                String temp = strFilterCriteria.substring(index, index+11);
                strFilterCriteria = strFilterCriteria.replaceFirst(temp, '\''+UserInfo.getUserid()+'\'');
            }
            
            //Supporting CurrentUserContact in filtercriteria
            while(strFilterCriteria.containsIgnoreCase('current_user_contact')) {
                String strContactId = '';
                if(!lstUser.isEmpty() && lstUser[0].ContactId != null) {
                    strContactId = lstUser[0].ContactId;
                    Integer index = strFilterCriteria.indexOfIgnoreCase('current_user_contact');
                    String temp = strFilterCriteria.substring(index, index+20);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '\''+strContactId+'\'');
                }
                else
                    strFilterCriteria = strFilterCriteria.substringAfter('current_user_contact');
            }
            
            if(String.isNotBlank(strFilterCriteria.trim())) {
                strFilterCriteria = strFilterCriteria.trim();
                
                if(strFilterCriteria.startsWithIgnoreCase('AND')) {
                    Integer index = strFilterCriteria.indexOfIgnoreCase('AND');
                    String temp = strFilterCriteria.substring(index, index+4);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '');
                }
                else if(strFilterCriteria.startsWithIgnoreCase('OR')) {
                    Integer index = strFilterCriteria.indexOfIgnoreCase('OR');
                    String temp = strFilterCriteria.substring(index, index+3);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '');
                }
            }
            if(String.isNotBlank(strFilterCriteria.trim()))
                return ' WHERE ' + strFilterCriteria.trim();
        }
        return '';
    }

    private static SL_FldObj[] getFldMap(String[] flds, String objName) {
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult rootObj = gdMap.get(objName).getDescribe();
        Map<String, Schema.SObjectField> rootFldMap = rootObj.fields.getMap();
        String strInvalidField = '';
        SL_FldObj[] fldMap = new SL_FldObj[]{};

        for(String key : flds) {
            key = rootFldMap.containsKey(key) ? rootFldMap.get(key).getDescribe().getName() : key; 
            String[] tempArry = key.split('\\.');

            if(tempArry.size() > 1) {
                Integer lstSize = tempArry.size();
                String finalFld = tempArry[lstSize-1].toLowerCase(); 
                
                Schema.Describesobjectresult finalObj;
                Schema.DescribeFieldResult finalFldRes;
                
                String[] actLabelArry = new String[]{};
                String actLabel = '';

                if(lstSize > 2) {
                    for(Integer i=0;i<=lstSize-2;i++) {
                        String tempFld = tempArry[i].toLowerCase();
        
                        if(tempFld.endsWith('__r')) {
                            tempFld = tempFld.removeEnd('__r') + '__c';
                        }
                        else {
                            tempFld += 'Id';
                        }
                        
                        strInvalidField = tempFld;
                        if(rootFldMap.containsKey(tempFld) || finalObj.fields.getMap().containsKey(tempFld)) {
                            strInvalidField = '';
                            if(i == 0) {
                                Schema.DescribeFieldResult dfr = rootFldMap.get(tempFld).getDescribe();
                                Schema.sObjectType[] refs = dfr.getReferenceTo();
                                
                                finalObj = refs[0].getDescribe();
                                actLabelArry.add(dfr.getLabel());
                            }
                            else {
                                Schema.DescribeFieldResult dfr = finalObj.fields.getMap().get(tempFld).getDescribe();
                                Schema.sObjectType[] refs = dfr.getReferenceTo();
                                
                                finalObj = refs[0].getDescribe();
                                actLabelArry.add(dfr.getLabel());
                            }
                        }
                    }
    
                    actLabel = String.join(actLabelArry,' > ');
                }
                else {
                    String tempFld = tempArry[0].toLowerCase();
    
                    if(tempFld.endsWith('__r')) {
                        tempFld = tempFld.removeEnd('__r') + '__c';
                    }
                    else {
                        tempFld += 'Id';
                    }
                    strInvalidField = tempFld;
                    if(rootFldMap.containsKey(tempFld)) {
                        strInvalidField = '';
                        Schema.DescribeFieldResult dfr = rootFldMap.get(tempFld).getDescribe();
                        Schema.sObjectType[] refs = dfr.getReferenceTo();
        
                        finalObj = refs[0].getDescribe();
                    }
                }

                Map<String, Schema.SObjectField> fieldMapTemp = finalObj.fields.getMap();
                
                strInvalidField = finalFld;
                if(fieldMapTemp.containsKey(finalFld)) {
                    strInvalidField = '';
                    Schema.DescribeFieldResult dfrTemp = fieldMapTemp.get(finalFld).getDescribe();
                    
                    actLabel += ((actLabel != '')?('.' + dfrTemp.getLabel()):(dfrTemp.getLabel()));
                    
                    String fldType = String.valueOf(dfrTemp.getType());
        
                    fldMap.add(createFldMap(key, actLabel, dfrTemp,strInvalidField));
                }
                else {
                    fldMap.add(createFldMap(key,'',null,strInvalidField)); 
                }
            }
            else {
                strInvalidField = key;
                if(rootFldMap.containsKey(key)) {
                    strInvalidField = '';
                    Schema.DescribeFieldResult dfr = rootFldMap.get(key).getDescribe();
                    fldMap.add(createFldMap(key,dfr.getLabel(),dfr,strInvalidField)); 
                }
                else {
                    fldMap.add(createFldMap(key,'',null,strInvalidField)); 
                }
            }
        }
        return fldMap;
    }

    private static SL_FldObj createFldMap(String apiName, String lbl, Schema.DescribeFieldResult dfr, String strInvalidField) {
        if(dfr != null) {
            String fldType = String.valueOf(dfr.getType());
            String lkupRelName = '';
            String lkupRelApiName = apiName;
            Boolean isRef;
    
            if(fldType == 'REFERENCE') {
                String[] tempArry = apiName.split('\\.');
                
                String[] relNameArry = new String[]{};
    
                if(tempArry.size()>2) {
                    for(Integer i=0;i<=tempArry.size()-2;i++) {
                        relNameArry.add(tempArry[i]);
                    }
    
                    lkupRelName = String.join(relNameArry,'.')+'.'+dfr.getRelationshipName()+'.Name';
                }
                else if(tempArry.size()==2) {
                    lkupRelName = tempArry[0]+'.'+dfr.getRelationshipName()+'.Name';
                }
                else {
                    lkupRelName = dfr.getRelationshipName()+'.Name';
                }
                isRef = true;
    
                // Id or Name should link to the record being displayed in the table
            } 
            else if(apiName == 'Id') {
                lkupRelName = apiName;
                isRef = true;
            } 
            else if(apiName == 'Name') {
                lkupRelName = apiName;
                lkupRelApiName = 'Id';
                isRef = true;
            } 
            else {
                isRef = false;
            }
            return new SL_FldObj(apiName,lbl,fldType,isRef,lkupRelApiName,lkupRelName,strInvalidField);
        }
        else {
            return new SL_FldObj(apiName,'','',false,'','',strInvalidField);            
        }
    }
    @AuraEnabled
    public static void deleteRecord(Id recordId){
        String objParent=recordId.getSObjectType().getDescribe().getName();
        String queryString='SELECT Id FROM '+objParent+' WHERE Id = \''+recordId+'\'';
        System.debug('queryString'+queryString);
        list<SObject> lstSObject=Database.query(queryString);
        System.debug('lstSObject'+lstSObject);
        Delete lstSObject;
    }
}