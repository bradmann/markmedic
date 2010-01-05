xquery version "1.0-ml";
xdmp:set-response-content-type("application/xml"),
<?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
type="text/xsl"?>,
<?xsltforms-options debug="yes"?>,
<html xmlns="http://www.w3.org/1999/xhtml"
xmlns:xf="http://www.w3.org/2002/xforms">
  <head>
    <title>Hello World in XForms</title>
    <xf:model>
      <xf:instance>
        <data xmlns="">
          <PersonGivenName/>
        </data>
      </xf:instance>
    </xf:model>
  </head>
  <body>
     <xf:input ref="PersonGivenName" incremental="true">
       <xf:label>Please enter your first name: </xf:label>
     </xf:input>
     <br />
     <xf:output value="concat('Hello ', PersonGivenName)">
       <xf:label>Output: </xf:label>
     </xf:output>
  </body>
</html>
