({
	doInit : function(component, event, helper) {
        
        var empty = [];
		
        if(component.get("v.inputList") != null && component.get("v.inputList").length!=0){

			component.set("v.thString",component.get("v.inputList")[0]);

			var inputList = component.get("v.inputList").slice(1);
			var colSize = Math.ceil((inputList.length/4));
			component.set("v.colSize",colSize);
			var outputList = [];

			
			/*for(var ii =0;ii<inputList.length;ii++){
				if(ii<4){
					var temp = outputList.push(inputList.slice(ii,ii+1));
				}else{
					var temp = outputList[ii%4].push(inputList[ii]);
				}
			}*/
			
            for(var ii = 0; ii < 4; ii++) {

				var temp = outputList.push(inputList.slice(ii,ii+1));
			}
            
			component.set("v.fieldList",outputList);

		}
	}
})