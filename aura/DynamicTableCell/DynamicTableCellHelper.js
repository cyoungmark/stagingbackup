({
    getRelName : function(curFld,curRec) {
        var relArry = curFld.lkupRelName.split('.');
        var arrySize = relArry.length;
        var cellVal = '';
        
        if(arrySize > 2) {
            for(var i=0;i<arrySize-1;i++) {
                var tempObj;
                var curTempFld = relArry[i];
                
                if(tempObj == null) {
                    tempObj = curRec[curTempFld];
                } else {
                    tempObj = tempObj[curTempFld];
                }
                
                if(i == arrySize-2 && tempObj != null) {
                    cellVal = tempObj[relArry[i+1]];
                }
            }
        } else if(arrySize === 1) {
            cellVal = curRec[relArry[0]];
        } else {
            cellVal = curRec[relArry[0]];
            if(cellVal) {
                cellVal = cellVal[relArry[1]];
            } else {
                cellVal = '';
            }
        }
        return cellVal;
    }
})