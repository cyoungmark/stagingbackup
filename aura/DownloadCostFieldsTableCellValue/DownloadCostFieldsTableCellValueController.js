({
	doInit  : function(component, event, helper) {
		var record = component.get("v.record");
        var field = component.get("v.field");
        component.set("v.cellValue", record[field.name]);
	}
})