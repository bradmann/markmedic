module namespace illmod = 'http://www.example.com/illness-model';

declare function illmod:search-illness($searchString as xs:string) as element(illness)* {

cts:search( xdmp:directory("/illnesses/")/illness, cts:word-query($searchString) )



};

