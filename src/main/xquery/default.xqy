

declare function local:get-search-result-points() {(
    
    fn:concat(
    "var people = [ ",
    
    fn:string-join(
        for $person at $i in /person
        let $uri := xdmp:node-uri($person)
        let $name := $person/biography/first-name/text()
        let $position := fn:concat($person//geo/lat/text(), "," , $person//geo/long/text()) 
        return
            fn:concat("['", fn:encode-for-uri($name) ,"', ",$position,", ",$i,"]") ,
        ","),
    
    "];")
)}; 
  
  
declare function local:mapScripts() as node()* {
    let $js-data := local:get-search-result-points()
    return
    (
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>,
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/medic-map.js"></script>,
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript">{$js-data}</script>
    )
};
    
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    {
        local:mapScripts()
    }
    </head>
    <body onload="initialize()">
        
        <div id="map_canvas" style="width:700px; height:400px"></div>
            
    </body>
</html>

