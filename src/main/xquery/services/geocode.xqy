module namespace geoc = 'http://www.example.com/geocode.xqy';

declare namespace kml="http://earth.google.com/kml/2.0";

declare function geoc:geocode-url($address as xs:string) as xs:string {

    let $key := "ABQIAAAAj-AX-GyPsKszUnZaUNQDgBT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQAX3NVWtWuL9ar3ZY2ys1AKwMsTw"
    let $url := fn:concat("http://maps.google.com/maps/geo?q=",
                    fn:encode-for-uri($address),
                    "&amp;output=xml&amp;sensor=false&amp;key=",
                    $key)
    
    return
    $url

};

declare function geoc:geocode-zip($zip as xs:string) as element(geo) {

    let $url := geoc:geocode-url($zip)
    let $kml := (xdmp:http-get($url))[2]
    let $point-string := $kml/kml:kml/kml:Response/kml:Placemark/kml:Point/kml:coordinates/text()
    let $coords := fn:tokenize($point-string,",")
    return
    
    
    element geo {
     element lat { $coords[1] },
     element long { $coords[2] }
    }

};

