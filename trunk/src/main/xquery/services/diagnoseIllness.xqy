module namespace diag = 'http://www.example.com/diagnoseIllness.xqy';


declare function diag:diagnose-illness-by-name($name as xs:string) as node() {

let $ill := (/illness[names/common-name = $name])[1]
return

if($ill) then
element illness-ref {
   element uri { xdmp:node-uri($ill) },
   element official-name { $ill/names/official-name/text() }
}
else
fn:error(xs:QName("ERROR"), "No illness found")

};


