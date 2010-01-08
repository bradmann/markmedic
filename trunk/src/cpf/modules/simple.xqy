xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";

import module namespace cvt = "http://marklogic.com/cpf/convert"   at "/MarkLogic/conversion/convert.xqy";

import module namespace person = "http://marklogic.com/person" at "person.xqy";

declare option xdmp:mapping "false";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:transition as node() external;
declare variable $cpf:options as element() external;

declare variable $doc as node() := fn:doc($cpf:document-uri);

declare function local:process () as empty-sequence () {
    let $person := person:make-person($doc)
    let $ill-rpts := 
        for $rpt in $person/medical/illness-reports/illness-report
        let $results := cts:search(/markmedic-rule, cts:reverse-query($rpt))
        let $els := 
            for $name in $results/name
            return <suggestion>{$name}</suggestion>
        let $_ := xdmp:log(text{("$els=",xdmp:quote($els))})
        let $new-rpt := element {fn:local-name($rpt)} 
                        {(<suggestions>{$els}</suggestions>, $rpt/node()[fn:local-name() ne "suggestions"])}
        return $new-rpt
    let $person := local:replace-illness-reports($person, $ill-rpts)
    return xdmp:document-insert(  fn:concat("/output/", cvt:basename($cpf:document-uri)  )  , $person)
};

declare function local:replace-illness-reports($person as element(person), $ill-rpts as element(illness-report)*) as element(person) {
    <person>
        {$person/node()[fn:local-name() ne "medical"]}
        <medical>
            {$person/medical/node()[fn:local-name() ne "illness-reports"]}
            <illness-reports>{$ill-rpts}</illness-reports>
        </medical>
    </person>
};

if (cpf:check-transition($cpf:document-uri, $cpf:transition)) then 
  (
        local:process(), 
        cpf:success( $cpf:document-uri, $cpf:transition, () )   
  ) 
else 
    ()