module namespace geoq = 'http://www.example.com/geoquery.xqy';

import module namespace const = "http://marklogic.com/constants" at "/common/constants.xqy";

declare namespace kml="http://earth.google.com/kml/2.0";

declare variable $MAPS-KEY as xs:string := const:get-google-key();

declare function geoq:geoquery-search($geo as element(geo), $proximity as xs:float) as element(person)* {
    let $point := cts:point($geo/lat, $geo/long)
    let $cir := cts:circle($proximity, $point)
    let $query := cts:element-pair-geospatial-query(xs:QName("geo"), xs:QName("lat"), xs:QName("long"), $cir)
    let $_ := xdmp:log($query)
    return cts:search(/person, $query)
};