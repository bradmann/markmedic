xquery version "1.0-ml";
let $SET := xdmp:set-response-content-type("application/xml")
let $uri := "/person1.xml"

return 
(
<?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
type="text/xsl"?>,
<!--?xsltforms-options debug="yes"?-->,
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:xf="http://www.w3.org/2002/xforms">
  <head>
    <title>Person Detail</title>
    <xf:model>
      <xf:instance>
        <data xmlns="">
          {
          doc($uri)
          }
        </data>
      </xf:instance>
      
      <xf:submission id="form1" method="put" action="person-action.xqy?uri={$uri}"/>
    </xf:model>
  </head>
  <body>
    <xf:group ref="person/biography">
     <xf:label>Biography:</xf:label>
     <xf:input ref="first-name" incremental="true">
       <xf:label>First Name:</xf:label>
     </xf:input>
     <xf:input ref="last-name" incremental="true">
       <xf:label>Last Name:</xf:label>
     </xf:input>
     <xf:input ref="address1" incremental="true">
       <xf:label>Address 1:</xf:label>
     </xf:input>
     <xf:input ref="address2" incremental="true">
       <xf:label>Address 2:</xf:label>
     </xf:input>
     <xf:input ref="city" incremental="true">
       <xf:label>City:</xf:label>
     </xf:input>
     <xf:input ref="state" incremental="true">
       <xf:label>State:</xf:label>
     </xf:input>
     <xf:input ref="zip" incremental="true">
       <xf:label>Zip Code:</xf:label>
     </xf:input>
     <xf:input ref="dob" incremental="true">
       <xf:label>Date of Birth:</xf:label>
     </xf:input>
    </xf:group>
     <xf:submit submission="form1">
        <xf:label>Save</xf:label>
     </xf:submit>
  </body>
</html>
)