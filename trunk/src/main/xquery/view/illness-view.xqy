module namespace illview = 'http://www.example.com/illness-view';

import module namespace illmod = 'http://www.example.com/illness-model' at "/model/illness-model.xqy";


declare function illview:searchIllness($searchString as xs:string) as element(div)*{

let $illnesses := illmod:search-illness($searchString)

return

for $ill in $illnesses 
return
element div {
   $ill/names/official-name/text()
}

};

