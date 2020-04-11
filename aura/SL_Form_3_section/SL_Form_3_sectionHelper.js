({
	getRecordId : function(component) {
        var recId = component.get("v.recordId");
		return recId;
	},
    getSObjectName : function(component) {
        var sObjectName = component.get("v.sObjectName");
		return sObjectName;
	},
    resetData : function(component) {
        component.set("v.sObj", null);
        var sObjCloned = JSON.parse(JSON.stringify(component.get("v.sObjCloned")))
        component.set("v.sObj", sObjCloned);
        component.set("v.isEdit", false);
    }
})