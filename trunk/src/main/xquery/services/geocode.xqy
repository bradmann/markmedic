module namespace geoc = 'http://www.example.com/geocode.xqy';

import module namespace const = "http://marklogic.com/constants" at "/common/constants.xqy";

declare namespace kml="http://earth.google.com/kml/2.0";

declare variable $MAPS-KEY as xs:string := const:get-google-key();

declare function geoc:geocode-url($address as xs:string) as xs:string {

    let $url := fn:concat("http://maps.google.com/maps/geo?q=",
                    fn:encode-for-uri($address),
                    "&amp;output=xml&amp;sensor=false&amp;key=",
                    $MAPS-KEY)
    
    return
    $url

};

declare function geoc:geocode-zip($zip as xs:string) as element(geo) {

    let $url := geoc:geocode-url($zip)
    let $kml := (xdmp:http-get($url))[2]
    let $point-string := ($kml/kml:kml/kml:Response/kml:Placemark/kml:Point/kml:coordinates/text())[1]
    let $coords := fn:tokenize($point-string,",")
    return
    
    
    element geo {
     element lat { $coords[1] },
     element long { $coords[2] }
    }

};

