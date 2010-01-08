xquery version "1.0-ml";

declare function local:do-get($uri as xs:string) as element() {
    <data>{fn:doc($uri)/node()}</data>
};

declare function local:do-post($data as element()) as element() {
    $data
};

declare function local:do-put($uri as xs:string, $data as element())  {
    let $ACT := xdmp:document-insert($uri, $data)
    return
    
    xdmp:redirect-response("/index.xqy")

    
};

let $uri := xdmp:get-request-field("uri")
let $LOG := xdmp:log(fn:concat("uri=", $uri))
let $method := xdmp:get-request-method()
let $request-body := xdmp:get-request-body()/data/illness
return 
if ($method eq "GET") then
    local:do-get($uri)
else if ($method eq "POST") then
    local:do-post($request-body)
else if ($method eq "PUT") then
    local:do-put($uri, $request-body)
else ()
    