import module namespace illview = 'http://www.example.com/illness-view' at "/view/illness-view.xqy";

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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>MarkMedic 5</title>
<link href="resources/css/markmedic.css" rel="stylesheet" type="text/css" />

    {
        local:mapScripts()
    }

</head>

<body onload="initialize()">
<div id="wrapper">
  <div id="header"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></div>
  <div id="leftcol">
    <form id="form1" name="form1" method="post" action="">
      <p>
        <input name="q" type="text" id="q" size="40" />
        <input type="submit" name="Submit" id="Submit" value="Search" />
      </p>
    
    </form>
    
     <div id="resultpanel">

{
        illview:searchIllness("")
}

     </div>
  </div>
  <div id="rightcol">
  
  <div id="map_canvas" style="width:570px; height:400px"></div>
  </div>
  
  <div id="footer"> </div>
</div>
</body>
</html>
