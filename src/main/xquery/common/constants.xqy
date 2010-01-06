module namespace const = "http://marklogic.com/constants";

declare variable $CONST-DOC-URI as xs:string := "/config/constants.xml";
declare variable $const as element(const:config) := fn:doc($CONST-DOC-URI)/const:config;

declare function const:get-google-key() as xs:string {
    $const/const:googlemapkey/text()
};
