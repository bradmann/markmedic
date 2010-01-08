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
      <xf:instance src="/endpoints/person-action.xqy?uri={$uri}" id="person" />
      <xf:instance id="new-symptom">
        <span>
        
        </span>
      </xf:instance>
      <xf:bind nodeset="person/biography/dob" type="xsd:date"/>
      <xf:bind nodeset="person/medical/vaccinations/vaccination/vac-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-start-date" type="xsd:date"/>
      <xf:bind nodeset="person/medical/illness-reports/illness-report/illness-end-date" type="xsd:date"/>
      <xf:submission id="save-form" method="put" action="/endpoints/person-action.xqy" instance="person" replace="instance">
      </xf:submission>
      <xf:submission id="cancel-form" method="put" action="/"/>      
    </xf:model>
let $template :=
    <span>    
    <div>

    </div>
    <div>
        <xf:output ref="person/uri" incremental="true">
           <xf:label>URI:</xf:label>
        </xf:output>
    </div>    

     <xf:label>Biography:</xf:label>

     <table class="outer">
         <tr>
             <td>
                <xf:label>First Name:</xf:label>
                <xf:input ref="/data/person/biography/first-name" incremental="true" ></xf:input>
             </td>
             <td>
                <xf:label>Last Name:</xf:label>
                <xf:input ref="/data/person/biography/last-name" incremental="true"/>
             </td>
             <td>
                <xf:label>Address 1:</xf:label>
                <xf:input ref="/data/person/biography/address1" incremental="true"/>
             </td>
             <td>
                <xf:label>Address 2:</xf:label>
                <xf:input ref="/data/person/biography/address2" incremental="true"/>
             </td>
         </tr>
         <tr>
             <td>
                <xf:label>City:</xf:label>
                 <xf:input ref="/data/person/biography/city" incremental="true"/>
             </td>
             <td>
                <xf:label>State:</xf:label>
                 <xf:input ref="/data/person/biography/state" incremental="true"/>
             </td>
             <td>
                <xf:label>Zip Code:</xf:label>
                 <xf:input ref="/data/person/biography/zip" incremental="true"/>
             </td>
             <td>
                <xf:label>Date of Birth:</xf:label>
                <xf:input ref="/data/person/biography/dob" incremental="true"/>
             </td>
         </tr>
     </table>

    <xf:label>Medical:</xf:label>
    <table style="border: solid 1px #ccc;">
        <tr>
        <td><xf:label>Vaccinations:</xf:label></td>
        </tr>

        <xf:repeat nodeset="/data/person/medical/vaccinations/vaccination" id="vac-rpt">
            <tr>
                <td>
                    <xf:select1 ref="vac-target" selection="open">
                          <xf:label>Target Illness:</xf:label>
                          {local:illness-select()}
                    </xf:select1>
                </td>
                <td>
                    <xf:input ref="vac-date" incremental="true">
                       <xf:label>Date:</xf:label>
                    </xf:input>
                </td>
             </tr>
        </xf:repeat>
    </table>
    <xf:label>Illnesses:</xf:label>
    <table style="border: solid 1px #ccc;">            
            <xf:repeat nodeset="/data/person/medical/illness-reports/illness-report" id="illrpt-rpt">
                <tr>
                    <td>           
                        <xf:select1 ref="illness-target" selection="open">
                              <xf:label>Illness Name:</xf:label>
                              {local:illness-select()}
                        </xf:select1>
                    </td>
                    <td>
                        <xf:input ref="illness-start-date" incremental="true">
                           <xf:label>Start Date:</xf:label>
                        </xf:input>
                    </td>
                    <td>
                        <xf:input ref="illness-end-date" incremental="true">
                           <xf:label>End Date:</xf:label>
                        </xf:input>
                    </td>
                    <td>
                        <xf:input ref="certainty" incremental="true">
                           <xf:label>Certainty:</xf:label>
                        </xf:input>
                    </td>
                    <td>                    
                        <xf:label>Symptoms:</xf:label>
                        <table>
                        <xf:repeat nodeset="/data/person/medical/illness-reports/illness-report/illness-symptoms/symptom" id="illsym-rpt">
                            <tr>
                                <td>
                                     <xf:input ref="." incremental="true" />
                                </td>
                                <td>
                                     <xf:trigger>
                                          <xf:label>x</xf:label>
                                          <xf:delete ev:event="DOMActivate" nodeset="." />
                                     </xf:trigger>
                                 </td>
                             </tr>  
                        </xf:repeat>
                        </table>               
                        <xf:trigger>
                           <xf:label>Add Symptom</xf:label>
                           <xf:insert nodeset="/data/person/medical/illness-reports/illness-report/illness-symptoms/symptom" position="after" at="count(illsym-rpt)" ev:event="DOMActivate"/>
                         </xf:trigger>                        
                    </td>
                    <td>
                        <div>Suggestions:</div>
                        <ul>
                           <xf:repeat nodeset="suggestions/suggestion">
                                <li><xf:output ref="name/official-name" /></li>
                           </xf:repeat>
                        </ul> 
                    </td>  
                </tr>
                <tr>
                    <td>
                         <xf:trigger>
                              <xf:label>x</xf:label>
                              <xf:delete ev:event="DOMActivate" nodeset="." />
                         </xf:trigger>
                    </td>
                </tr>
            </xf:repeat>
    </table>
    <div>
         <xf:trigger>
           <xf:label>Add Illness</xf:label>
           <xf:insert nodeset="/data/person/medical/illness-reports/illness-report" position="after" at="count(illrpt-rpt)" origin="" ev:event="DOMActivate"/>
         </xf:trigger>
    </div>
   
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