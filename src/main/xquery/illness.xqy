xquery version "1.0-ml";
let $SET := xdmp:set-response-content-type("application/xml")
let $uri := "/illness1.xml"

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
      <xf:submission id="form1" method="put" action="illness-action.xqy?uri={$uri}"/>
    </xf:model>
  </head>
  <body>
     <xf:input ref="illness/names/official-name" incremental="true">
       <xf:label>Illness Name:</xf:label>
     </xf:input>
     <br />
     <xf:label>Symptoms:</xf:label>
     <xf:repeat nodeset="illness/symptoms/symptom" id="symptom-rpt">
         <xf:input ref="." />
         <xf:trigger>
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." at="index('symptom-rpt')" />
         </xf:trigger>         
     </xf:repeat>
     <xf:trigger>
       <xf:label>Add Symptom</xf:label>
       <xf:insert nodeset="illness/symptoms/symptom" position="before" at="count(illness/symptoms/symptom)" ev:event="DOMActivate"/>
     </xf:trigger>
     <br />
     <xf:label>Treatments:</xf:label>
     <xf:repeat nodeset="illness/treatments/treatment" id="treatment-rpt">
         <xf:input ref="." /> 
         <xf:trigger>
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." at="index('treatment-rpt')" />
         </xf:trigger>         
     </xf:repeat>
     <xf:trigger>
       <xf:label>Add Treatment</xf:label>
       <xf:insert nodeset="illness/treatments/treatment" position="before" at="count(illness/treatments/treatment)" ev:event="DOMActivate"/>
     </xf:trigger>
     <br />
     <xf:label>Causes:</xf:label>
     <xf:repeat nodeset="illness/causes/cause" id="cause-rpt">
         <xf:input ref="." />
         <xf:trigger>
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." at="index('cause-rpt')" />
         </xf:trigger>   
     </xf:repeat>
     <xf:trigger>
       <xf:label>Add Cause</xf:label>
       <xf:insert nodeset="illness/causes/cause" position="before" at="count(illness/causes/cause)" ev:event="DOMActivate"/>
     </xf:trigger>
     <br/>
     <xf:output ref="illness/names/official-name">
       <xf:label>Output: </xf:label>
     </xf:output>
     <br />
     <xf:submit submission="form1">
        <xf:label>Save</xf:label>
     </xf:submit>
  </body>
</html>
)