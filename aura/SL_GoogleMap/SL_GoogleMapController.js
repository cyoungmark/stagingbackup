({
   jsLoaded: function(component, event, helper) {
    var location = component.get("v.location");
      var map = L.map('map', {zoomControl: false, tap: false})
                  .setView([location.latitude, location.longitude], 14);
      L.tileLayer(
       'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
       {
              attribution: 'Silverline © 2017'
       }).addTo(map);
      component.set("v.map", map);
      helper.addMarker(component, event, helper);
  } 
  
})