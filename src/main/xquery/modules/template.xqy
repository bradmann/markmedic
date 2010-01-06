xquery version "1.0-ml";

module namespace tmpl = "http://marklogic.com/markmedic/template";
declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

declare function tmpl:render($model, $left-content, $right-content) {
    (
    <?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
    type="text/xsl"?>,
    <!--?xsltforms-options debug="yes"?-->,
    <?css-conversion no?>,
    <html 
    xmlns:xf="http://www.w3.org/2002/xforms"
    xmlns:ev="http://www.w3.org/2001/xml-events"
    >
      <head>
        <title>Illness Detail</title>
        <link rel="stylesheet" type="text/css" href="/resources/css/markmedic.css"/>
        {$model}
      </head>
      <body>
      
      <div id="wrapper">
      <div id="header"><a href="/"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></a></div>
      <div id="leftcol">{$left-content}</div>
      <div id="rightcol">{$right-content}</div>
      
      <div id="footer"> </div>
    </div>
         
      </body>
    </html>
    )
};