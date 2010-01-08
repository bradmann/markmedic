
import module namespace geoc = 'http://www.example.com/geocode.xqy' at "/services/geocode.xqy";
import module namespace geoq = 'http://www.example.com/geoquery.xqy' at "/services/geoquery.xqy";
import module namespace const = 'http://marklogic.com/constants' at "/common/constants.xqy";

declare function local:manageRequestFields() as element(field)* {

    let $fieldNames := xdmp:get-request-field-names()
    for $name in $fieldNames 
    return 
        element field {
            element name { $name },
            element value { xdmp:get-request-field($name,"") }
        }
};

declare function local:valueFromField($field as element(field)?) as xs:string {
        if($field) then
            fn:concat($field/value/text(),"")
        else
            ""
};

declare function local:mapScripts() as node()* {
    (
    <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/jquery-1.3.2.min.js"></script>,
    <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>,
    <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/medic-map.js"></script>,
    <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/circle-overlay.js"></script>
    )
};

declare function local:buildJavascriptPointArray($people as element(person)*) {
    fn:concat(
    "var people = [ ",
    
    fn:string-join(
        for $person at $i in $people
        let $uri := xdmp:node-uri($person)
        let $name := $person/biography/first-name/text()
        let $position := fn:concat($person//geo/lat/text(), "," , $person//geo/long/text()) 
        return
            fn:concat("['", fn:encode-for-uri($name) ,"', ",$position,", ",$i, ", '",$uri,"'"  , "]") ,
        ","),
    
    "];")
};

let $fields := local:manageRequestFields()
let $log := xdmp:log($fields)
let $my-zip := local:valueFromField($fields[name = 'my-zip'])
let $my-geo := if ($my-zip) then geoc:geocode-zip($my-zip) else ()
let $nearby-illnesses := if ($my-geo) then geoq:geoquery-search($my-geo, 16.0) else ()
return


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>MarkMedic 5</title>
<link href="resources/css/markmedic.css" rel="stylesheet" type="text/css" />
{
        local:mapScripts()
}
<script type="text/javascript">
    {local:buildJavascriptPointArray($nearby-illnesses)}
    {
    
    let $coords := $my-geo//text()
    return
    fn:concat("
    var localPoint = new google.maps.LatLng(",  fn:concat($coords[1],",", $coords[2])   ," );")}
</script>
</head>

<body onload="initializeLocal()">
<div id="wrapper">
  <div id="header"><a href="/"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></a></div>
  <div id="leftcol">
    <form id="form2" name="form2" method="post" action="myrisk.xqy">
        Zip :
        <input name="my-zip" type="text" id="my-zip" size="5" value="{$my-zip}"/>
        <input type="submit" name="Submit" id="Submit" value="Evaluate My Risk" />
    </form>    
     <div id="resultpanel">
      <h3>Risk Assement for location: {$my-zip}</h3>
      Illness count in my area: {fn:count($nearby-illnesses)}
      <div id="risk_assessment"></div>
      <h3>Alerts for this location: </h3>
      
     </div>
     <form id="form1" name="form1" method="post" action="index.xqy">
       <p><input type="submit" name="Back" id="Back" value="Back to Main Page" /></p>
    </form>
  </div>
  <div id="rightcol">
    <div id="map_canvas" style="width:540px; height:400px"></div>
  </div>

  
  <div id="footer"> </div>
</div>
</body>
</html>