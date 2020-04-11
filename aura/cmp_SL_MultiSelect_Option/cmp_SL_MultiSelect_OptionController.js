({
    init: function(component, event, helper) {
 
       //note, we get options and set options_
       //options_ is the private version and we use this from now on.
       //this is to allow us to sort the options array before rendering
       var options = component.get("v.options");
        
        console.log('options===111====CHECK IT OUT=============>>>>'+ component.get("v.options")); 
       console.log('options===222====CHECK IT OUT=============>>>>', options); 
       
        if(options){
            options.sort(function compare(a,b) {
                      if (a.value == 'All'){
                        return -1;
                      }
                      else if (a.value < b.value){
                        return -1;
                      }
                      if (a.value > b.value){
                        return 1;
                      }
                      return 0;
                    });
     
           component.set("v.options_",options);
           console.log('options===333====CHECK IT OUT=============>>>>'+ component.get("v.options_")); 
           var values = helper.getSelectedLabels(component);
            console.log('-----values-1--'+values);
           helper.setInfoText(component,values);
           console.log('-----values-2--'+values);
        }
            
     },
    handleSelection: function(component, event, helper) {
      var item = event.currentTarget;
      if (item && item.dataset) {
        var value = item.dataset.value;
        var selected = item.dataset.selected;
     
        var options = component.get("v.options_");
     
        //shift key ADDS to the list (unless clicking on a previously selected item)
        //also, shift key does not close the dropdown (uses mouse out to do that)
        if (event.shiftKey) {
          options.forEach(function(element) {
            if (element.value == value) {
                element.selected = !element.selected;
            }
          });
        } else {
          options.forEach(function(element) {
            if (element.value == value) {
                element.selected = !element.selected;
            } 
          });
          //var mainDiv = component.find('main-div');
          //$A.util.removeClass(mainDiv, 'slds-is-open');
        }
        component.set("v.options_", options);
        var values = helper.getSelectedValues(component);
        var labels = helper.getSelectedLabels(component);
         
          console.log('values===========>>>', values);
          console.log('labels===========>>>', labels);
          
        helper.setInfoText(component,labels);
        helper.despatchSelectChangeEvent(component,values);
     
      }
    },
    handleClick: function(component, event, helper) {
        var mainDiv = component.find('main-div');
        $A.util.addClass(mainDiv, 'slds-is-open');
    },
    
    handleMouseLeave: function(component, event, helper) {
        component.set("v.dropdownOver",false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
    },
    
    handleMouseEnter: function(component, event, helper) {
        component.set("v.dropdownOver",true);
    },
    handleMouseOutButton: function(component, event, helper) {
        window.setTimeout(
          $A.getCallback(function() {
            if (component.isValid()) {
              //if dropdown over, user has hovered over the dropdown, so don't close.
              if (component.get("v.dropdownOver")) {
                return;
              }
              var mainDiv = component.find('main-div');
              $A.util.removeClass(mainDiv, 'slds-is-open');
            }
          }), 200
        );
      }
})