module namespace const = "http://marklogic.com/constants";
(:
declare variable $CONST-DOC-URI as xs:string := "/config/constants.xml";
declare variable $const as element(const:config) := fn:doc($CONST-DOC-URI)/const:config;
:)
declare function const:get-google-key() as xs:string {
    (:let $key := $const/const:googlemapkey
    return $key 
    :)
    "ABQIAAAAj-AX-GyPsKszUnZaUNQDgBT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQAX3NVWtWuL9ar3ZY2ys1AKwMsTw"
};
