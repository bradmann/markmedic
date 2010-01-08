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
   element{fn:local-name($el)} {(<uri>{$uri}</uri>,$el/node()[fn:local-name() ne "uri"])}
};

declare function local:process ($person as element(person)) as element(person) {
    let $ill-rpts := 
        for $rpt in $person/medical/illness-reports/illness-report
        let $results := cts:search(/markmedic-rule, cts:reverse-query($rpt))
        let $els := 
            for $name in $results/name
            return <suggestion>{$name}</suggestion>
        let $_ := xdmp:log(text{("$els=",xdmp:quote($els))})
        let $new-rpt := element {fn:local-name($rpt)} 
                        {(<suggestions>{$els}</suggestions>, $rpt/node()[fn:local-name() ne "suggestions"])}
        let $_ := xdmp:log(text{("$new-rpt=",xdmp:quote($new-rpt))})
        return $new-rpt
    let $_ := xdmp:log(text{("$ill-rpts=",xdmp:quote($ill-rpts))})
    let $person := local:replace-illness-reports($person, $ill-rpts)
    return $person
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
    let $uri := $data/uri[1]/text()
    let $new-data := local:return-stripped($data)
    let $new-uri := if ($uri) then xdmp:url-decode($uri) else fn:concat("/submissions/", xdmp:hash32($new-data), ".xml")
    let $new-data := local:set-uri($new-data, $new-uri)
    let $new-data := local:process($new-data)
    let $_ := xdmp:log(text{("$uri=", $new-uri)})
    let $_ := xdmp:document-insert(xdmp:url-encode ($new-uri), $new-data, (), ("persons", "submissions"))
    return <data>{$new-data}</data>
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
    