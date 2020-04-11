({
    doInit : function(cmp, ev, help) {
        var curFld = cmp.get('v.curFld');
        var curRec = cmp.get('v.curRec');
        
        var cellVal;
        var lkupId;
        
        if(curFld.apiName.includes('.')) {
            var tempArry = curFld.apiName.split('.');
            var arrySize = tempArry.length;
            
            var tempObj;
            
            if(arrySize > 2) {
                for(var i=0;i<arrySize-1;i++) {
                    var curTempFld = tempArry[i];
                    
                    if(tempObj == null) {
                        tempObj = curRec[curTempFld];
                    } else {
                        tempObj = tempObj[curTempFld];
                    }
                    
                    if(i == arrySize-2 && tempObj != null && !curFld.isRef) {
                        cellVal = tempObj[tempArry[i+1]];
                    } else if(i == arrySize-2 && tempObj != null && curFld.isRef) {
                        cellVal = help.getRelName(curFld,curRec);
                        lkupId = tempObj[tempArry[i+1]];
                        console.log('test');
                    }
                }
            } else {
                if(curFld.isRef) {
                    var relArry = curFld.lkupRelName.split('.');
                    
                    if(relArry.length == 3) {
                        var tempRelObj = curRec[relArry[0]][relArry[1]];
                        
                        if(tempRelObj != null) {
                            cellVal = tempRelObj[relArry[2]];
                            lkupId = curRec[tempArry[0]][tempArry[1]];
                        }
                    } else {
                        cellVal = curRec[relArry[0]][relArry[1]];
                        lkupId = curRec[tempArry[0]][tempArry[1]];
                    }
                } else {
                    cellVal = curRec[tempArry[0]][tempArry[1]];
                }
            }
        } else {
            if(curFld.isRef) {
                if(curFld.apiName == 'Id' || curFld.apiName == 'Name') {
                    cellVal = curRec[curFld.apiName];
                } else {
                    var tempArry = curFld.lkupRelName.split('.');
                    var tempRelObj = curRec[tempArry[0]];
                    cellVal = tempRelObj != null ? curRec[tempArry[0]][tempArry[1]] : '';
                }
                lkupId = curRec[curFld.lkupRelAPI];
                
            } else {
                cellVal = curRec[curFld.apiName];
            }
        }
        cmp.set('v.cellVal',cellVal);
        cmp.set('v.lkupId',lkupId);
    }
})