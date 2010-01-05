xquery version "1.0-ml";
let $SET := xdmp:set-response-content-type("application/xml")
let $uri := "/illness1.xml"

return 
(
<?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
type="text/xsl"?>,
<!--?xsltforms-options debug="yes"?-->,
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:xf="http://www.w3.org/2002/xforms">
  <head>
    <title>Illness Detail</title>
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
     <xf:repeat nodeset="illness/symptoms/symptom">
         <xf:input ref="." />
     </xf:repeat>
     <br />
     <xf:label>Treatments:</xf:label>
     <xf:repeat nodeset="illness/treatments/treatment">
         <xf:input ref="." />
     </xf:repeat>
     <br />
     <xf:label>Causes:</xf:label>
     <xf:repeat nodeset="illness/causes/cause">
         <xf:input ref="." />
     </xf:repeat>
     <br />
     
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