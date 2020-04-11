({
  setInfoText: function(component, values) {
    console.log('---setInfoText-values---'+values);
    if (values.length == 0) {
      component.set("v.infoText", "Select an option...");
    }
    if (values.length == 1) {
      component.set("v.infoText", values[0]);
    }
    else if (values.length > 1) {
      component.set("v.infoText", values.length + " options selected");
    }
  },

  getSelectedValues: function(component){
    var options = component.get("v.options_");
    var values = [];
    options.forEach(function(element) {
      if (element.selected) {
        values.push(element.value);
      }
    });
     console.log('-----values----'+values);
    return values;
  },

  getSelectedLabels: function(component){
    var options = component.get("v.options_");
    var labels = [];
    options.forEach(function(element) {
      if (element.selected) {
        labels.push(element.label);
      }
    });
      
      console.log('-----labels----'+labels);
    return labels;
  },

  despatchSelectChangeEvent: function(component,values){
    var compEvent = component.getEvent("selectChange");
    console.log('---------------',values);
    compEvent.setParams({ "values": values });
    compEvent.fire();
  }
})