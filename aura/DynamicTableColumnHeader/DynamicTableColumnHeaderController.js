({
    sort : function(cmp, ev, help) {
        var apiName = cmp.get('v.apiName');
        var isSorted = cmp.get('v.isSorted');
        var sortDir = cmp.get('v.sortDir');
        if(isSorted) {
            sortDir = sortDir === 'ASC' ? 'DESC' : 'ASC';
        } 
        else {
            sortDir = 'ASC';
        }
        var sortEvent = cmp.getEvent('sortEvent');
        sortEvent.setParams({'fld' : apiName, 'dir' : sortDir});
        sortEvent.fire();
    },
    
    showHideFilterInput : function(cmp, ev, help) {
        var elementId = ev.currentTarget.id;
        var value = document.getElementById(cmp.get('v.apiName') + '_input').value;
        $A.util.toggleClass(document.getElementById(elementId + '_input'), 'slds-hide');
        cmp.set('v.isFilterOn', !cmp.get('v.isFilterOn'));
        
        var appEvent = $A.get("e.c:evt_SL_ColumnFilters");
        appEvent.setParams({
            "fieldApiName" : cmp.get('v.apiName'),
            "fieldValue" : cmp.get('v.isFilterOn') ? value : null
        });
        appEvent.fire();
    },
    
    search : function(cmp, ev, help) {
        var value = document.getElementById(cmp.get('v.apiName') + '_input').value;
        var appEvent = $A.get("e.c:evt_SL_ColumnFilters");
        appEvent.setParams({
            "fieldApiName" : cmp.get('v.apiName'),
            "fieldValue" : value
        });
        appEvent.fire();
    }
})