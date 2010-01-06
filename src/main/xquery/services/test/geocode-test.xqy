(: XQuery main module :)

import module namespace geoc = 'http://www.example.com/geocode.xqy' at "/services/geocode.xqy";

geoc:geocode-zip('90004')