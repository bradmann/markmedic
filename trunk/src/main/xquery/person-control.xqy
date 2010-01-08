xquery version "1.0-ml";

import module namespace tmpl="http://marklogic.com/markmedic/template" at "/modules/template.xqy";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

declare function local:illness-select() {
  (<xf:item><xf:label>(Please Select)</xf:label><xf:value>(Please Select)</xf:value></xf:item>,
  for $doc in fn:collection("illnesses")
  let $off-name := $doc/illness/names/official-name/text()
  let $_ := xdmp:log(fn:concat("$off-name='", $off-name, "'"))
  let $_ := xdmp:log(fn:concat("$doc='", xdmp:quote($doc), "'"))
  return 
  <xf:item><xf:label>{$off-name}</xf:label><xf:value>{$off-name}</xf:value></xf:item>
  )
};

let $_ := xdmp:set-response-content-type("application/xml")
let $uri := xdmp:get-request-field('uri')
let $model :=
    <xf:model>
      <xf:instance src="person-action.xqy?uri={$uri}" id="person" />
      <!--xf:instance id="new-symptom">
        <span>
        <xf:input ref="person/medical/illness-reports/illness-report/illness-symptoms/illness-symptom" incremental="true" />
        <xf:trigger appearance="minimal">
              <xf:label>x</xf:label>
              <xf:delete ev:event="DOMActivate" nodeset="." />
        </xf:trigger>  
        </span>
      </xf:instance-->
      <xf:bind nodeset="person/biography/dob" type="xsd:date"/>
      <xf:bind nodeset="person/medical/vaccinations/vaccination/vac-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-start-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-end-date" type="xsd:date"/>
      <xf:submission id="save-form" method="put" action="person-action.xqy" instance="person" replace="instance">
      </xf:submission>
      <xf:submission id="cancel-form" method="put" action="/"/>      
    </xf:model>
let $template :=
    <span>    
    <div>
        <xf:output ref="person/uri" incremental="true">
           <xf:label>URI:</xf:label>
        </xf:output>
    </div>
    
    <div>Suggestions:</div>
    <ul>
       <xf:repeat nodeset="person/suggestions/suggestion">
            <li><xf:output ref="name/official-name" /></li>
       </xf:repeat>
    </ul> 
    <xf:group ref="person/biography">
     <xf:label>Biography:</xf:label>
     <xf:group>
     <table>
     <tr>
     <td>
     <xf:input ref="first-name" incremental="true">
       <xf:label>First Name:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="last-name" incremental="true">
       <xf:label>Last Name:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="address1" incremental="true">
       <xf:label>Address 1:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="address2" incremental="true">
       <xf:label>Address 2:</xf:label>
     </xf:input>
     </td>
     </tr>
     <tr>
     <td>
     <xf:input ref="city" incremental="true">
       <xf:label>City:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="state" incremental="true">
       <xf:label>State:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="zip" incremental="true">
       <xf:label>Zip Code:</xf:label>
     </xf:input>
     </td>
     <td>
     <xf:input ref="dob" incremental="true">
       <xf:label>Date of Birth:</xf:label>
     </xf:input>
     </td>
     </tr>
     </table>
     </xf:group>
    </xf:group>

    <xf:group ref="person/medical">
        <xf:label>Medical:</xf:label>
        <xf:group>
        <xf:label>Vaccinations:</xf:label>
        <xf:repeat nodeset="vaccinations/vaccination" id="vac-rpt">
            <xf:group>
                <xf:select1 ref="vac-target" selection="open">
                      <xf:label>Target Illness:</xf:label>
                      {local:illness-select()}
                </xf:select1>
                <xf:input ref="vac-date" incremental="true">
                   <xf:label>Date:</xf:label>
                </xf:input>
            </xf:group>
        </xf:repeat>
        </xf:group>
        <xf:group>
            <xf:label>Illnesses:</xf:label>
            <table>
            <tr>
            <xf:repeat nodeset="illness-reports/illness-report" id="illrpt-rpt">
                <td>
                <xf:group>                
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
                              <xf:label>x</xf:label>
                              <xf:delete ev:event="DOMActivate" nodeset="." />
                         </xf:trigger>  
                    </xf:repeat>
                    <xf:trigger>
                       <xf:label>Add Symptom</xf:label>
                       <xf:insert nodeset="instance('new-symptom')" position="after" at="count(illsym-rpt)" ev:event="DOMActivate"/>
                     </xf:trigger>
                </xf:group>
                <xf:trigger>
                      <xf:label>x</xf:label>
                      <xf:delete ev:event="DOMActivate" nodeset="." />
                 </xf:trigger>
                 
                 </xf:group>
                 </td>
               </xf:repeat>
               </tr>
               </table>
               <xf:trigger>
                   <xf:label>Add Illness</xf:label>
                   <xf:insert nodeset="illness-reports/illness-report" position="after" at="count(illrpt-rpt)" ev:event="DOMActivate"/>
                 </xf:trigger>
        </xf:group>        
    </xf:group>  
   
        <xf:textarea ref="person/medical/history"><xf:label>History:</xf:label></xf:textarea>

    <br/>
    <xf:submit submission="cancel-form">
        <xf:label>Cancel</xf:label>
     </xf:submit>
     <xf:submit submission="save-form">
        <xf:label>Save</xf:label>
     </xf:submit>
    </span>
return tmpl:render("Person Detail", $model, $template, ())