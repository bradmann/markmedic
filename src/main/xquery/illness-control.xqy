xquery version "1.0-ml";

let $SET := xdmp:set-response-content-type("application/xml")
let $uri := xdmp:get-request-field('uri')

return 
(
<?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
type="text/xsl"?>,
<!--?xsltforms-options debug="yes"?-->,
<?css-conversion no?>,
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:xf="http://www.w3.org/2002/xforms"
xmlns:ev="http://www.w3.org/2001/xml-events"
>
  <head>
    <title>Illness Detail</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/markmedic.css"/>
    <xf:model>
      <xf:instance>
        <data xmlns="">
          {
          doc($uri)
          }
        </data>
      </xf:instance>
      <xf:submission id="save-form" method="put" action="illness-action.xqy?uri={$uri}"/>
      <xf:submission id="cancel-form" method="get" action="/"/>
    </xf:model>
  </head>
  <body>
  
  <div id="wrapper">
  <div id="header"><a href="/"><img src="resources/images/banner.gif" width="970" height="206" alt="MarkMedic banner" /></a></div>
  <div id="leftcol">
  
     <xf:input ref="illness/names/official-name" incremental="true">
       <xf:label>Illness Name:</xf:label>
     </xf:input>
     
     <xf:group>
     <xf:label>Symptoms:</xf:label>
         <xf:repeat nodeset="illness/symptoms/symptom" id="symptom-rpt">
             <xf:input ref="." />
             <xf:trigger>
                  <xf:label>x</xf:label>
                  <xf:delete ev:event="DOMActivate" nodeset="." />
             </xf:trigger>         
         </xf:repeat>
         <xf:trigger>
           <xf:label>Add Symptom</xf:label>
           <xf:insert nodeset="illness/symptoms/symptom" position="after" at="count(illness/symptoms/symptom)" ev:event="DOMActivate"/>
         </xf:trigger>
     </xf:group>
     <xf:label>Treatments:</xf:label>
     <xf:repeat nodeset="illness/treatments/treatment" id="treatment-rpt">
         <xf:input ref="." /> 
         <xf:trigger>
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." />
         </xf:trigger>         
     </xf:repeat>
     <xf:trigger>
       <xf:label>Add Treatment</xf:label>
       <xf:insert nodeset="illness/treatments/treatment" position="after" at="count(illness/treatments/treatment)" ev:event="DOMActivate"/>
     </xf:trigger>
     
     <xf:label>Causes:</xf:label>
     <xf:repeat nodeset="illness/causes/cause" id="cause-rpt">
         <xf:input ref="." />
         <xf:trigger>
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." />
         </xf:trigger>   
     </xf:repeat>
     <xf:trigger>
       <xf:label>Add Cause</xf:label>
       <xf:insert nodeset="illness/causes/cause" position="after" at="count(illness/causes/cause)" ev:event="DOMActivate"/>
     </xf:trigger>
     
     <hr/>
     <xf:submit submission="cancel-form">
        <xf:label>Cancel</xf:label>
     </xf:submit>
     <xf:submit submission="save-form">
        <xf:label>Save</xf:label>
     </xf:submit>
     
     
       </div>
  <div id="rightcol">
  

  </div>
  
  <div id="footer"> </div>
</div>
     
  </body>
</html>
)