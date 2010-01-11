import module namespace illview = 'http://www.example.com/illness-view' at "/view/illness-view.xqy";
import module namespace illmod = 'http://www.example.com/illness-model' at "/model/illness-model.xqy";


declare function local:get-search-result-points($searchString as xs:string?) {(
    
    let $illnames := illmod:search-illness($searchString)//official-name/text()
    let $query := cts:or-query(
    
            for $term in $illnames
            return
            cts:element-value-query(
                xs:QName("illness-target"), 
                $term)
                    )
    
    
    return
    
    fn:concat(
    "var people = [ ",
    
    fn:string-join(
        for $person at $i in (cts:search(/person[fn:string-length(.//lat) >0],$query))[1 to 250]
        let $uri := xdmp:node-uri($person)
        let $name := $person/biography/first-name/text()
        let $position := fn:concat($person//geo/lat/text(), "," , $person//geo/long/text()) 
        return
            fn:concat("['", fn:encode-for-uri($name) ,"', ",$position,", ",$i, ", '",$uri,"'"  , "]") ,
        ","),
    
    "];")
)}; 
  
  
declare function local:mapScripts($searchString as xs:string?) as node()* {
    let $js-data := local:get-search-result-points($searchString)
    return
    (
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/jquery-1.3.2.min.js"></script>,
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>,
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript" src="/resources/js/medic-map.js"></script>,
        <script xmlns="http://www.w3.org/1999/xhtml" type="text/javascript">{$js-data}</script>
    )
};


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

let $fields := local:manageRequestFields()
let $log := xdmp:log($fields)
let $illness-search-string := local:valueFromField($fields[name = 'illness-search-term'])


        


return


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>MarkMedic 5</title>
<link href="resources/css/markmedic.css" rel="stylesheet" type="text/css" />

    {
        local:mapScripts($illness-search-string)
    }
<script>
<!--
    function clearAll() {
        window.location.href="/";
    }
    
//-->
</script>
</head>

<body onload="initialize()">
<div id="wrapper">
  <div id="header"><a href="/"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></a></div>
  <div id="leftcol">
    <form id="form1" name="form1" method="post" action="index.xqy">
      <p>
        <input name="illness-search-term" type="text" id="illness-search-term" size="30" value="{$illness-search-string}"/>
        <input type="submit" name="Submit" id="Submit" value="Search" />
        <input type="button" name="Clear" id="clear" value="X" onclick="clearAll()" />
        
      </p>
    
    </form>
    
     <div id="resultpanel">
        {
            illview:searchIllness($illness-search-string)
        }
        
        
        <a href="/templates/illness-control.xqy"><img src="resources/images/plusbutton.gif" alt="Add an illness"/></a>
     </div>
  </div>
  <div id="rightcol">
  
  <div id="right_buttons">
    <form id="form2" name="form2" method="post" action="myrisk.xqy">
        Zip :
        <input name="my-zip" type="text" id="my-zip" size="5" />
        <input type="submit" name="Submit" id="Submit" value="Evaluate My Risk" />
    </form>
  </div>
  <br style="clear:both"/>
    
  
  <div id="map_canvas" style="width:540px; height:350px"></div>
  
   <div  id="article_results"  style="width:540px">
    
    {
       illview:getRelatedArtices($illness-search-string)
    }
    <p><a href="">More articles</a></p>
    </div>
  
  
  </div>
  <div id="footer"> </div>
</div>
</body>
</html>


