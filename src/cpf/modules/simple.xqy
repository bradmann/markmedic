xquery version "1.0-ml";

import module namespace cpf = "http://marklogic.com/cpf" at "/MarkLogic/cpf/cpf.xqy";



declare option xdmp:mapping "false";

declare variable $cpf:document-uri as xs:string external;
declare variable $cpf:transition as node() external;
declare variable $cpf:options as element() external;


declare variable $DOC as node() := fn:doc($cpf:document-uri);


declare function this:process () as empty-sequence () {
   
   
 
   let $existing := $DOC/illness
   let $newnode :=  <blossom>testing</blossom>
   
   xdmp:node-insert-child( $existing, $newnode )

  
   
};

if (cpf:check-transition($cpf:document-uri,$cpf:transition)) then 
  (
        this:process(), 
        cpf:success( $cpf:document-uri, $cpf:transition, () )   
  ) 
else 
    ()

  