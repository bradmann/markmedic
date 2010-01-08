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
    let $results := cts:search(/markmedic-rule, cts:reverse-query($person))
    let $els := 
        for $name in $results/name
        return <suggestion>{$name}</suggestion>
    let $person := element {fn:local-name($person)} 
                    {(<suggestions>{$els}</suggestions>, $person/child::node())}
    return xdmp:document-insert(  fn:concat("/output/", cvt:basename($cpf:document-uri)  )  , $person)
};

if (cpf:check-transition($cpf:document-uri, $cpf:transition)) then 
  (
        local:process(), 
        cpf:success( $cpf:document-uri, $cpf:transition, () )   
  ) 
else 
    ()