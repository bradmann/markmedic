xquery version "1.0-ml";

declare function local:return-stripped-descent($el) {
   ($el/text(),
   for $child in $el/element()
   return local:return-stripped($child)
   )
};

declare function local:return-stripped($el) {
   if (not($el/text()=("(Please Select)","(Please Enter Text)"))) then
      element {fn:local-name($el)} {local:return-stripped-descent($el)}
   else ()
};

declare function local:set-uri($el, $uri) {
   element{fn:local-name($el)} {(<uri>{$uri}</uri>,$el/child::node())}
};

declare function local:set-uri-descent($el, $uri) {
   ($el/text(),
   for $child in $el/element()
   return local:set-uri($child, $uri)
   )
};

declare function local:process ($person as element(person)) as element(person) {
    let $results := cts:search(/markmedic-rule, cts:reverse-query($person))
    let $els := 
        for $name in $results/name
        return <suggestion>{$name}</suggestion>
    let $person := element {fn:local-name($person)} 
                    {(<suggestions>{$els}</suggestions>, $person/child::node())}
    return $person
};

declare function local:do-get($uri as xs:string) as element() {
    let $doc := if ($uri) then fn:doc($uri) else ()
    let $doc := if ($doc) then $doc else fn:doc("/empty-person.xml")
    return
        <data>{$doc}</data>
};

declare function local:do-post($data as element()) as element() {
    $data
};

declare function local:do-put($data as element()) {  
    let $uri := $data/uri/text()
    let $new-data := local:return-stripped($data)
    let $new-uri := if ($uri) then xdmp:url-decode($uri) else fn:concat("/submissions/", xdmp:hash32($new-data))
    let $new-data := local:set-uri($new-data, $new-uri)
    let $_ := xdmp:document-insert(xdmp:url-encode ($new-uri), $new-data, (), ("persons", "submissions"))
    return <data>{local:process($new-data)}</data>
};

let $uri := xdmp:get-request-field("uri")
let $LOG := xdmp:log(fn:concat("uri=", $uri))
let $method := xdmp:get-request-method()
let $request-body := xdmp:get-request-body()/data/person
return 
if ($method eq "GET") then
    local:do-get($uri)
else if ($method eq "POST") then
    local:do-post($request-body)
else if ($method eq "PUT") then
    local:do-put($request-body)
else ()
    