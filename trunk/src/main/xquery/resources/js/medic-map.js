

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


function initialize() {
    var myOptions = {
    	    zoom: 3,
    	    center: new google.maps.LatLng(40, -95),
    	    mapTypeId: google.maps.MapTypeId.TERRAIN
    	  }
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

    bounds = new google.maps.LatLngBounds();
    setMarkers(map, people);
    //map.fitBounds(bounds);
}



function setMarkers(map, locations) {
	for (var i = 0; i < locations.length; i++) {
		var point = locations[i];
		var myLatLng = new google.maps.LatLng(point[2], point[1]);
		
		var marker = new google.maps.Marker({
			position: myLatLng,
			map: map,
			icon: __RED_PIN_ICON,
			title: unescape(point[0])
		});
		

        //bounds.extend(myLatLng);
	}
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

*/
