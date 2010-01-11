xquery version "1.0-ml";

import module namespace tmpl="http://marklogic.com/markmedic/template" at "/modules/template.xqy";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

let $_ := xdmp:set-response-content-type("application/xml")
let $uri := xdmp:get-request-field('uri')
let $model :=
    <xf:model>
        <xf:instance src="/endpoints/illness-action.xqy?uri={$uri}" id="illness" />
        <xf:submission id="save-form" method="put" action="/endpoints/illness-action.xqy?uri={$uri}" replace="instance" instance="illness">
        </xf:submission>
        <xf:submission id="cancel-form" method="get" action="/"/>
    </xf:model>
let $content :=
    <span>
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
    </span>
return tmpl:render("Illness Detail", $model, $content, ())
