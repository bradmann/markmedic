xquery version "1.0-ml";

declare namespace xf = "http://www.w3.org/2002/xforms";

declare function local:illness-select() {
   for $doc in fn:collection("illness")
  let $off-name := $doc/illness/names/official-name/text()
  let $LOG := xdmp:log(fn:concat("$off-name='", $off-name, "'"))
  let $LOG := xdmp:log(fn:concat("$doc='", xdmp:quote($doc), "'"))
  return 
  <xf:item><xf:label>{$off-name}</xf:label><xf:value>{$off-name}</xf:value></xf:item>
};

let $SET := xdmp:set-response-content-type("application/xml")
let $uri := "/person1.xml"

return 
(
<?xml-stylesheet href="resources/xsltforms/xsltforms.xsl"
type="text/xsl"?>,
<!--?xsltforms-options debug="yes"?-->,
<?css-conversion no?>,
<html 
xmlns:xf="http://www.w3.org/2002/xforms"
xmlns:ev="http://www.w3.org/2001/xml-events"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <head>
    <title>Person Detail</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/global.css"/>
    
    <xf:model>
      <xf:instance id="builder" src="person-action.xqy?uri={$uri}" />
      <xf:bind nodeset="person/biography/dob" type="xsd:date"/>
      <xf:bind nodeset="person/medical/vaccinations/vaccination/vac-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-start-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-end-date" type="xsd:date"/>
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
    
    <xf:group ref="person/medical">
        <xf:label>Vaccinations:</xf:label>
        <xf:repeat nodeset="vaccinations/vaccination" id="vac-rpt">
            <xf:group ref=".">
                <xf:input ref="vac-date" incremental="true">
                   <xf:label>Date:</xf:label>
                </xf:input>
                <xf:select1 ref="vac-target" selection="open">
                      <xf:label>Target Illness:</xf:label>
                      {local:illness-select()}
                </xf:select1>
            </xf:group>
        </xf:repeat>
        <xf:group>
            <xf:label>Illnesses:</xf:label>
            <xf:repeat nodeset="illness-reports/illness-report" id="illrpt-rpt">
                <xf:select1 ref="illness-target" selection="open">
                      <xf:label>Illness Name:</xf:label>
                      {local:illness-select()}
                </xf:select1>
                <xf:input ref="illness-start-date" incremental="true">
                   <xf:label>Start Date:</xf:label>
                </xf:input>
                <xf:input ref="illness-end-date" incremental="true">
                   <xf:label>End Date:</xf:label>
                </xf:input>
                <xf:input ref="certainty" incremental="true">
                   <xf:label>Certainty:</xf:label>
                </xf:input>
                
                <xf:group>
                    <xf:label>Symptoms:</xf:label>
                    <xf:repeat nodeset="illness-symptoms/illness-symptom" id="illsym-rpt">
                        <xf:input ref="." incremental="true" />
                        <xf:trigger appearance="minimal">
                              <xf:label><img height="15" src="http://www.psdgraphics.com/wp-content/uploads/2009/03/psd-delete-icon.jpg"/></xf:label>
                              <xf:delete ev:event="DOMActivate" nodeset="." />
                         </xf:trigger>  
                    </xf:repeat>
                    <xf:trigger>
                       <xf:label>Add Symptom</xf:label>
                       <xf:insert nodeset="illness-symptoms/illness-symptom" position="after" at="count(illsym-rpt)" ev:event="DOMActivate"/>
                     </xf:trigger>
                </xf:group>
                <xf:trigger>
                      <xf:label>x</xf:label>
                      <xf:delete ev:event="DOMActivate" nodeset="." at="index('illrpt-rpt')" />
                 </xf:trigger>
               </xf:repeat>
               <xf:trigger>
                   <xf:label>Add Illness</xf:label>
                   <xf:insert nodeset="illness-reports/illness-report" position="after" at="count(illrpt-rpt)" ev:event="DOMActivate"/>
                 </xf:trigger>
        </xf:group> 
       
        
        <xf:textarea ref="history"><xf:label>History:</xf:label></xf:textarea>
    </xf:group>  
    
     <xf:submit submission="form1">
        <xf:label>Save</xf:label>
     </xf:submit>
  </body>
</html>
)