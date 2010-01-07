xquery version "1.0-ml";

declare function local:do-get($uri as xs:string) as element() {
    let $doc := if ($uri) then fn:doc($uri) else ()
    let $doc := if ($doc) then $doc else fn:doc("/empty-person.xml")
    return
        <data>{$doc}</data>
};

declare function local:do-post($data as element()) as element() {
    $data
};

declare function local:do-put($uri as xs:string, $data as element()) {    
    let $new-uri := if ($uri) then $uri else fn:concat("/submissions/", xdmp:hash32($data))
    let $_ := xdmp:document-insert($new-uri, $data, (), ("persons", "submissions"))
    return xdmp:redirect-response(fn:concat("/person-control.xqy?uri=", $new-uri))
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
    local:do-put($uri, $request-body)
else ()
    