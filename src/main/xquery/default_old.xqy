

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
        
        <div style="width=100%; height=100%">
            <div id="headarea" style="background-color:red">Header</div>
            <div id="bodyarea" style="background-color:blue">
                <div id="left-panel" style="float:left; background-color:white">
                    Search Illnesses: <input></input>
                    <button type="submit">Submit</button>
                    <br/>
                    <div>
                    <a href="#">Result</a> result result <br/>
                    <a href="#">Result</a> result result <br/>
                    <a href="#">Result</a> result result <br/>
                    <a href="#">Result</a> result result <br/>
                    <a href="#">Result</a> result result <br/>
                    
                    </div>
                </div>
                <div id="map_canvas" style="float:right; width:570px; height:400px"></div>
                <br style="clear:both"/>
            </div>
            <div id="footarea" style="background-color:red">Footer</div>
        </div>
            
    </body>
</html>

