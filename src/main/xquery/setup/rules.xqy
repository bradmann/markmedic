xquery version "1.0-ml";

for $ill in collection("illnesses")
let $ors :=
   for $sym in $ill//symptoms/symptom
   return cts:word-query(string($sym))
let $name := $ill/illness/names/official-name
let $uri := fn:concat("/rules/", fn:encode-for-uri($name), ".xml")
let $content:=
<markmedic-rule>
      <name>{$name}</name>
      <uri>{$uri}</uri>
      {cts:or-query($ors)}
</markmedic-rule>
return (xdmp:document-insert($uri, $content, (), "rules"), $uri)
