({
    doInit : function(cmp, ev, help) {
        var spinner = cmp.find('initSpinner');
        $A.util.removeClass(spinner, "slds-hide");
        var fldList = cmp.get('v.fldList');
        var objName = cmp.get('v.objName');
        var sortFld = cmp.get('v.sortFld');
        var sortDir = cmp.get('v.sortDir');
        var pgSize = cmp.get('v.pgSize');
        var queryFilter = cmp.get('v.queryFilter');
        var relationshipField = cmp.get('v.relationshipField');
        var parentRecordId = cmp.get('v.recordId');
        var parentField = cmp.get('v.parentField');
        var isFilterByParent = cmp.get('v.filterByParent');
        
        //on click of clear icon setting value as blank in the filter input
        if(cmp.get('v.glblFltrEnabled'))
            cmp.find("globalFilterInput").set('v.value', '');
        
        var action = cmp.get("c.dynQry");
        action.setParams({
            "fldList":fldList,
            "objName":objName,
            "sortFld":sortFld,
            "sortDir":sortDir,
            "queryFilter":queryFilter,
            "parentRecordId" : parentRecordId,
            "relationshipField" : relationshipField,
            "parentField" : parentField,
            "filterByParent" : isFilterByParent
        }); 
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            $A.util.addClass(spinner, "slds-hide");
            
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var tempRes = JSON.parse(res);
                var allRecs = tempRes.recs;
                var nextInfo = help.nextPg(allRecs, 1, pgSize);
                
                var fldMapTemp = [];
                var errorMsg = '';
                tempRes.fldMap.forEach(function(record, index) {
                    if(record['invalidField'] == '')
                        fldMapTemp.push(record);   
                    else
                        errorMsg += ', ' + record['invalidField'];
                });
                if(errorMsg != '')
                    cmp.set("v.invalidFldMsg", 'Data for ' + errorMsg.slice(1) + (errorMsg.split(',').length > 2 ? ' columns' : ' column') + ' are not displayed. Please check the field API names in the table configuration.');
                
                cmp.set("v.createAccess", tempRes.createAccess);
                cmp.set("v.sortDir", tempRes.sortDir);
                cmp.set("v.sortFld", tempRes.sortFld);
                cmp.set("v.allRecs", allRecs);
                cmp.set("v.fltrRecs", allRecs);
                cmp.set("v.curRecs", nextInfo.curRecs);
                cmp.set("v.totPgs", Math.ceil(allRecs.length/pgSize));
                cmp.set("v.fldMap", fldMapTemp);
                cmp.set("v.errMsg", tempRes.errMsg);
                cmp.set("v.objName", tempRes.titledObjectName);
                
                var columnSorting = {};
                fldMapTemp.forEach(function(record, index) {
                    columnSorting[record.apiName] = '';    
                });
                cmp.set('v.columnFilters', columnSorting);
                var btn = cmp.find("closeBTN");
                $A.util.addClass(btn, 'hide');
            }
            else if(state === "INCOMPLETE") {
            }
                else if(state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    }
                    else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    createNewRecord : function(cmp, ev, help) {
        var createRecordEvent = $A.get("e.force:createRecord");

        if(cmp.get('v.objName') == 'State_Pricing__c'){
            createRecordEvent.setParams({
            "entityApiName": cmp.get('v.objName'),
            "defaultFieldValues":{
                'Item_Update__c': cmp.get('v.recordId')
            }
        });
        }
        else{
            createRecordEvent.setParams({
            "entityApiName": cmp.get('v.objName')
        });
        }
        createRecordEvent.fire();
        
    },
    
    lastPg: function(cmp,evt,help) {
        if(cmp.get('v.glblFltrEnabled')) {
            var allRecs = cmp.get('v.fltrRecs');
        } 
        else {
            var allRecs = cmp.get('v.allRecs');
        }
        
        var lastPg = cmp.get('v.totPgs');
        var pgSize = cmp.get('v.pgSize');
        
        var nextInfo = help.nextPg(allRecs, lastPg, pgSize);
        
        cmp.set('v.curRecs',nextInfo.curRecs);
        cmp.set('v.currPg',nextInfo.currPg);
    },
    
    nextPg: function(cmp,evt,help) {
        if(cmp.get('v.glblFltrEnabled')){
            var allRecs = cmp.get('v.fltrRecs');
        } 
        else {
            var allRecs = cmp.get('v.allRecs');
        }
        
        var currPg = cmp.get('v.currPg');
        var pgSize = cmp.get('v.pgSize');
        
        var nextInfo = help.nextPg(allRecs, currPg+1, pgSize);
        
        cmp.set('v.curRecs',nextInfo.curRecs);
        cmp.set('v.currPg',nextInfo.currPg);
    },
    
    prevPg: function(cmp,evt,help) {
        if(cmp.get('v.glblFltrEnabled')){
            var allRecs = cmp.get('v.fltrRecs');
        } 
        else {
            var allRecs = cmp.get('v.allRecs');
        }
        var currPg = cmp.get('v.currPg');
        var pgSize = cmp.get('v.pgSize');
        
        var nextInfo = help.nextPg(allRecs, currPg-1, pgSize);
        
        cmp.set('v.curRecs',nextInfo.curRecs);
        cmp.set('v.currPg',nextInfo.currPg);
    },
    
    firstPg: function(cmp,evt,help) {
        if(cmp.get('v.glblFltrEnabled')){
            var allRecs = cmp.get('v.fltrRecs');
        } 
        else {
            var allRecs = cmp.get('v.allRecs');
        }
        var pgSize = cmp.get('v.pgSize');
        
        var nextInfo = help.nextPg(allRecs, 1, pgSize);
        
        cmp.set('v.curRecs',nextInfo.curRecs);
        cmp.set('v.currPg',nextInfo.currPg);
    },
    
    handleFilters : function(cmp,evt,help) {
        var columnObj = cmp.get("v.columnFilters");
        columnObj[evt.getParam("fieldApiName")] = evt.getParam("fieldValue");
        var fltrVal = null;
        if(cmp.get('v.glblFltrEnabled'))
            fltrVal = cmp.find('globalFilterInput').get('v.value');
        
        var btn = cmp.find("closeBTN"); 
        if(fltrVal && fltrVal.length > 0) {
            $A.util.removeClass(btn, 'hide');    
        }
        else {
            $A.util.addClass(btn, 'hide');
        }
        
        help.handleFilters(cmp,cmp.get('v.allRecs'),fltrVal,columnObj);
    },
    
    handleSort: function(cmp,evt,help) {
        evt.stopPropagation();
        
        var allRecs = cmp.get('v.allRecs');
        var fldMap = cmp.get('v.fldMap');
        var sortFld = evt.getParam('fld');
        var sortDir = evt.getParam('dir');
        var currPg = cmp.get('v.currPg');
        var pgSize = cmp.get('v.pgSize');
        
        var sortedVals = help.sort(cmp.get('v.fltrRecs'), fldMap, sortFld, sortDir, currPg, pgSize);
        
        cmp.set('v.curRecs', sortedVals.curRecs);
        cmp.set('v.sortFld', sortedVals.sortFld);
        cmp.set('v.sortDir', sortedVals.sortDir);
        cmp.set('v.currPg', sortedVals.currPg);
        cmp.set('v.fltrRecs', sortedVals.fltrRecs);
    },
    editActionItem: function(cmp,evt,help) {
        var recordId = evt.currentTarget.id;
        help.navigateToComponent(recordId, false);
    }
})