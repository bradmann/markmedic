
import module namespace geoc = 'http://www.example.com/geocode.xqy' at "/services/geocode.xqy";



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
let $my-zip := local:valueFromField($fields[name = 'my-zip'])
let $my-geo := geoc:geocode-zip($my-zip)
return


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>MarkMedic 5</title>
<link href="resources/css/markmedic.css" rel="stylesheet" type="text/css" />



</head>

<body onload="initialize()">
<div id="wrapper">
  <div id="header"><a href="/"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></a></div>
  <div id="leftcol">
    <form id="form1" name="form1" method="post" action="index.xqy">
      <p>
       <input type="submit" name="Back" id="Back" value="Back to Main Page" />
      </p>
    
    </form>
    
     <div id="resultpanel">
        {
            "My Risk Assesment"
        }
        
     </div>
  </div>
  <div id="rightcol">
  
    My Assesment
  
  </div>

  
  <div id="footer"> </div>
</div>
</body>
</html>