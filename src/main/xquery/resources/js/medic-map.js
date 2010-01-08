

var map;
var bounds;

var pathCoordinates = [];
var poly;

var __RED_PIN_ICON;
var __BLUE_PIN_ICON;

var __DRAW_POLY = false;
var __DRAW_BOX = false;

var colorSet = "#AA6600";
var colorDrawing = "#0000CC";

var infowindowLevel = 0;
var infowindow = new google.maps.InfoWindow();

function initialize() {
    var myOptions = {
    	    zoom: 3,
    	    center: new google.maps.LatLng(40, -95),
    	    mapTypeId: google.maps.MapTypeId.TERRAIN
    	  }
    
    __RED_PIN_ICON = new google.maps.MarkerImage("/resources/images/mm_20_red.png",
  	      new google.maps.Size(12, 20), // This marker is 20 pixels wide by 32 pixels tall.
  	      new google.maps.Point(0,0),   // The origin for this image is 0,0.
  	      new google.maps.Point(6, 20)); // The anchor for this image is the base of the flagpole at 0,32.
    
    
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    bounds = new google.maps.LatLngBounds();
    setMarkers(map, people);
    map.fitBounds(bounds);
}

function initializeLocal() {
    var myOptions = {
    	    zoom: 3,
    	    center: new google.maps.LatLng(40, -95),
    	    mapTypeId: google.maps.MapTypeId.TERRAIN
    	  }
    
    __RED_PIN_ICON = new google.maps.MarkerImage("/resources/images/mm_20_red.png",
  	      new google.maps.Size(12, 20), // This marker is 20 pixels wide by 32 pixels tall.
  	      new google.maps.Point(0,0),   // The origin for this image is 0,0.
  	      new google.maps.Point(6, 20)); // The anchor for this image is the base of the flagpole at 0,32.
    __BLUE_PIN_ICON = new google.maps.MarkerImage("/resources/images/mm_20_blue.png",
  	      new google.maps.Size(12, 20), // This marker is 20 pixels wide by 32 pixels tall.
  	      new google.maps.Point(0,0),   // The origin for this image is 0,0.
  	      new google.maps.Point(6, 20)); // The anchor for this image is the base of the flagpole at 0,32.
    
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    bounds = new google.maps.LatLngBounds();
    setMarkers(map, people);
    createMarker(map, localPoint);
    var circle = new CircleOverlay(localPoint, 16.0, "#0000FF", 3, 1.0, "#0000FF", .3);
    circle.initialize(map);
    circle.redraw();
    map.fitBounds(circle.bounds);
    
    var count = people.length;
    var risk = "low";
    
    if (count > 50) risk = "moderate";
    if (count > 150) risk = "high";
    
    var colors = {"low": "#00FF00", "moderate": "#FFFF00", "high": "#FF0000"};
    $("#risk_assessment").html(risk);
    $("#risk_assessment").css("background-color", colors[risk]);
}

function setMarkers(map, locations) {
	for (var i = 0; i < locations.length; i++) {
		var point = locations[i];
		var myLatLng = new google.maps.LatLng(point[2], point[1]);
		var uri = point[4];
		
		var marker = new google.maps.Marker({
			position: myLatLng,
			map: map,
			icon: __RED_PIN_ICON,
			title: unescape(point[0])
		});
		
		attachInfowindow(marker,i,uri);
		
        bounds.extend(myLatLng);
	}
}

function createMarker(map, latlng) {
	var marker = new google.maps.Marker({
		position: latlng,
		map: map,
		icon: __BLUE_PIN_ICON,
		title: "My Location"
	});
	bounds.extend(latlng);
}

function attachInfowindow(marker, number, uri) {


	var url = "/services/get-person-window-by-uri.xqy?uri=" + uri;
	
	  google.maps.event.addListener(marker, 'click', function() {
		  
		var request = initRequest();
       request.open("GET", url, false);
       request.send("");
       var dataR = request.responseText;
		infowindow.setContent(dataR);
	    infowindow.open(map,marker);
	    
	  });
}

/**

function addLatLng(event) {
	if (__DRAW_POLY) {
	  var path = poly.getPath();
	  path.insertAt(pathCoordinates.length, event.latLng);
	}
}

function clickClear(){
	clearPoly();
    resubmit();
}

function polyButtonClicked() {
  if (__DRAW_POLY) {
    document.getElementById("polyButton").disabled = true;
    endPoly();
    if(!__DRAW_POLY){
      document.getElementById("polyButton").value = "Draw Polygon";
      document.getElementById("polyButton").disabled = false;
      resubmit();
    } else {
      document.getElementById("polyButton").disabled = false;
    }
  } else {
    document.getElementById("polyButton").disabled = true;
    startPoly();
    document.getElementById("polyButton").value = "Set Polygon";
    document.getElementById("polyButton").disabled = false;
  }
}


function startPoly() {
    __DRAW_POLY = true;
    __DRAW_BOX = false;
    clearPoly();
//    __VERTICES = [];
//    __MARKERS = [];
}



function endPoly() {
    if (!__DRAW_POLY) return;

    var path = poly.getPath();
    var len = path.getLength();
    if(len>2){
	    var vertex0 = path.getAt(0);
	    path.insertAt(path.getLength(), vertex0);

	    var polyOptions = {
		path: path,
		strokeColor: colorSet,
		strokeOpacity: 1.0,
		strokeWeight: 3
	    }
	    poly.setOptions(polyOptions);

	   // Set the geospatial parameter based on coordiantes
           var geoParms = "";
           for(var i=0; i<path.getLength(); i++){
             var latLng = path.getAt(i);
             geoParms += '<p x="' + latLng.lng() +'" y="' + latLng.lat() + '"/>';
           }
           geoParms = '<ps>' + geoParms + '</ps>';
           url = "/service/add-geo-poly-term.xqy?p=" + escape(geoParms);

           request = initRequest();
           request.open("GET", url, false);
           request.send("");


	    __DRAW_POLY = false;
    } else {
    	alert("You must specify at least 2 sides to set a polygon");
    }



}


function initPoly() {
    var path = new google.maps.MVCArray();
    var len = geoPoly.length;
    var color = (len>0) ? colorSet : colorDrawing;
    
    var polyOptions = {
		path: path,
		strokeColor: color,
		strokeOpacity: 1.0,
		strokeWeight: 3
    }
    for(var i=0; i<len; i++){
    	var point = geoPoly[i];
    	path.insertAt(path.getLength(), new google.maps.LatLng(point[1],point[0]));
    }
    poly.setOptions(polyOptions);	

}



function clearPoly() {
    var path = new google.maps.MVCArray();
    var polyOptions = {
	path: path,
	strokeColor: colorDrawing,
	strokeOpacity: 1.0,
	strokeWeight: 3
    }
    poly.setOptions(polyOptions);
    
    
    url = "/service/clear-geo-term.xqy";
    request = initRequest();
    request.open("GET", url, false);
    request.send("");
}

function resubmit() {
	document.getElementById("searchform").submit();
}

*/
// Utility function to make AJAX calls easier 
function initRequest() {
	request = false;
	
	try {
		request = new XMLHttpRequest();
	} catch (trymicrosoft) {
		try {
			request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (othermicrosoft) {
			try {
				request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (failed) {
				request = false;
			}  
		}
	}
	if (!request) {
	     alert("Error initializing XMLHttpRequest!");
	}
	
	return request;
}


