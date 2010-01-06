module namespace illmod = 'http://www.example.com/illness-model';

declare function illmod:search-illness($searchString as xs:string) as element(illness)* {

xdmp:directory("/illnesses/")/illness

};

