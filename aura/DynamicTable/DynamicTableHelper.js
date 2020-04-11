({
    loadMoreRecords : function(cmp, help) {
        var currRecs = cmp.get('v.curRecs');
        var totRecs = cmp.get('v.fltrRecs');
        var pageSize = cmp.get('v.pgSize');
        var size1 = currRecs.length;
        
        for(var i = currRecs.length; i < (size1 + pageSize); i++) {
            if(i < totRecs.length)
                currRecs.push(totRecs[i]);
        }
        cmp.set('v.currPg', cmp.get('v.currPg') + 1);
        cmp.set('v.curRecs',currRecs);
    },
    
    handleFilters : function(cmp, allRecs, fltrVal, columnObj) {
        var finalRecs = [];
        var tempRecs = allRecs;
        if(!$A.util.isEmpty(fltrVal)) {
            tempRecs = allRecs.filter(function(curRec) {
                var propArray = Object.getOwnPropertyNames(curRec);
                
                for(var i = 0; i < propArray.length; i++) {
                    // ignore salesforce attributes which is auto attached to sobjects
                    if(propArray[i] === 'attributes') {
                        continue;
                    }
                    var propertyVal = curRec[propArray[i]];
                    
                    if(typeof propertyVal === 'object'){
                        // need to add code here for filtering based on relationship fields
                        // instead we only search on the name of the object
                        propertyVal = propertyVal.Name.toString().toLowerCase();
                    } 
                    else {
                        propertyVal = propertyVal.toString().toLowerCase();
                    }
                    
                    if(propertyVal.indexOf(fltrVal) != -1){
                        return true;
                    }
                }
                return false;
            }, this);            
        }
        
        tempRecs.forEach(function(record, index){
            var isMatch = false;
            for(var key in columnObj) {
                var recordValue = record[key];
                if(!columnObj[key] || columnObj[key].trim() == '') {
                    isMatch = true;
                    continue;
                }
                if(recordValue && columnObj[key] && recordValue.toString().toLowerCase().trim().indexOf(columnObj[key].toString().toLowerCase().trim()) > -1) {
                    isMatch = true;   
                } else {
                    isMatch = false;
                    break;
                }
            }
            if(isMatch) {
                finalRecs.push(record);    
            }
        });
        
        var fldMap = cmp.get('v.fldMap');
        var sortFld = cmp.get('v.sortFld');
        var sortDir = cmp.get('v.sortDir');
        var pgSize = cmp.get('v.pgSize');
        
        var sortedVals = this.sort(finalRecs, fldMap, sortFld, sortDir, 1, pgSize);
        
        cmp.set('v.curRecs', sortedVals.curRecs);
        cmp.set('v.sortFld', sortedVals.sortFld);
        cmp.set('v.sortDir', sortedVals.sortDir);
        cmp.set('v.currPg', sortedVals.currPg);
        cmp.set('v.totPgs', sortedVals.totPgs);
        cmp.set('v.fltrRecs', sortedVals.fltrRecs);
        cmp.set('v.glblFltrTimer', null);
    },
    
    /* Parameters:
    allRecs: Array containing all records in the table
    nxtPg: Integer of the next page of records to return

    Returns: Object with the updated list of records to display on this page
             and the new page number
    */
    nextPg: function(allRecs, nextPg, pgSize) {
        var allRecsLength = allRecs.length;
        
        var start = (nextPg-1)*pgSize;
        var endPgIndex = nextPg*pgSize;
        var end = endPgIndex > allRecsLength ? allRecsLength : endPgIndex;
        
        var newList = allRecs.slice(start, end);
        
        return {"curRecs": newList, "currPg": nextPg};
    },
    
    // Sorts and filters records from allRecs and stores in fltrRecs
    sort : function(filteredRecs, fldMap, sortFld, sortDir, currPg, pgSize) {
        var sortField = sortFld;  
        
        // If the field we are sorting on is a relationship, sort on the name
        // not on the id
        for(var i = 0; i < fldMap.length; i++){
            if(fldMap[i].apiName === sortField) {
                if(fldMap[i].isRef && fldMap[i].lkupRelName !== '') {
                    sortField = fldMap[i].lkupRelName;
                }
                break;
            }
        }
        // we want to access helper function while sorting
        var that = this;
        
        filteredRecs.sort(function(recA, recB){
            var recAVal = that.getRelName(sortField, recA);
            var recBVal = that.getRelName(sortField, recB);
            
            //this is handling null value as well and populating them in the last 
            if(!recAVal || recAVal === null){
                return 1;
            } 
            else if(!recBVal || recBVal === null){
                return -1;
            } 
            else if(recAVal > recBVal){
                return sortDir === 'ASC' ? 1 : -1;
            } 
            else if(recAVal < recBVal) {
                return sortDir === 'ASC' ? -1 : 1;
            } 
            else return 0;
        });
        
        // We just want to recalc the current page, so pass currPg as is 
        // instead of incremented up or down
        var nextInfo = this.nextPg(filteredRecs, currPg, pgSize);
        
        var totPgs = Math.ceil(filteredRecs.length/pgSize);
        
        return {
            'fltrRecs': filteredRecs,
            'curRecs' : nextInfo.curRecs,
            'sortFld' : sortField,
            'sortDir' : sortDir,
            'totPgs' : totPgs,
            'currPg' : nextInfo.currPg
        };
    },
    
    // Mostly copied from DynamicTableCellHelper.js, not sure of a better way to 
    // share helper code
    getRelName : function(curFld,curRec) {
        var relArry = curFld.split('.');
        var arrySize = relArry.length;
        var cellVal = '';
        
        if(arrySize > 2) {
            for(var i=0;i<arrySize-1;i++) {
                var tempObj;
                var curTempFld = relArry[i];
                
                if(tempObj == null) {
                    tempObj = curRec[curTempFld];
                }
                else {
                    tempObj = tempObj[curTempFld];
                }
                
                if(i == arrySize-2 && tempObj != null) {
                    cellVal = tempObj[relArry[i+1]];
                }
            }
        } 
        else if(arrySize === 1) {
            cellVal = curRec[relArry[0]];
        } 
        else {
            cellVal = curRec[relArry[0]];
            if(cellVal) {
                cellVal = curRec[relArry[1]];
            } 
            else {
                cellVal = '';
            }
        }
        return cellVal;
    }
})