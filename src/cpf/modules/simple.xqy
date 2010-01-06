xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";

import module namespace person = "http://marklogic.com/person" at "/markmedic/person.xqy";

declare namespace this = "http://markmedic/processing";

declare option xdmp:mapping "false";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:transition as node() external;
declare variable $cpf:options as element() external;


declare variable $doc as node() := fn:doc($cpf:document-uri);


declare function this:process () as empty-sequence () {
    xdmp:document-insert("/output2/obvious.xml", person:make-person($doc))
};

if (cpf:check-transition($cpf:document-uri, $cpf:transition)) then 
  (
        this:process(), 
        cpf:success( $cpf:document-uri, $cpf:transition, () )   
  ) 
else 
    ()

  