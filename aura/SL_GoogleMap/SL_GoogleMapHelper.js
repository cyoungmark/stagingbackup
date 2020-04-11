({
   addMarker : function(component, event, helper){
        var location=component.get("v.location");
        var map = component.get('v.map');
        var latLng = [location.latitude, location.longitude];
        L.marker(latLng).addTo(map);
        component.set("v.map",map);
  } 
})