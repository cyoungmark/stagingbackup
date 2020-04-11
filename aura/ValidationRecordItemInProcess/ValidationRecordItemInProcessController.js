({
	openModel: function(cmp) {
        console.log('no entre');
        if(!cmp.get("v.isDoneRendering")){
          	cmp.set("v.isDoneRendering", true);
                console.log('entre');
            var action = cmp.get("c.provideInformationModal");
    
            action.setParams({ idItemInProcess : cmp.get("v.recordId") });
            console.log(cmp.get("v.recordId"));
            
            action.setCallback(this, function(response) {
                console.log("===>");
                console.log(response.getState());
                var state = response.getState();
                if (state === "SUCCESS") {

					console.log(response.getReturnValue());
                    if(response.getReturnValue())
                   		cmp.set("v.isOpen", response.getReturnValue());
                    else
						cmp.set("v.isDoneRendering", false);
                    
                }
            });
			$A.enqueueAction(action);
            $A.get('e.force:refreshView').fire(); 
        }
        
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },
})