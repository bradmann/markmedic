module namespace illview = 'http://www.example.com/illness-view';

import module namespace illmod = 'http://www.example.com/illness-model' at "/model/illness-model.xqy";


declare function illview:searchIllness($searchString as xs:string?) as element(div)*{

    (: let $log := xdmp:log(fn:concat("View: the search string is '",$searchString,"'")) :)

    let $illnesses := illmod:search-illness($searchString)
    
    return
    
    for $ill in $illnesses 
    return

<div>
    <p>
    <b>{$ill/names/official-name/text()}</b> ( )
    </p>
    <p>
    {$ill/description/text()}
    </p>
    <p>
    Symptoms: {fn:string-join($ill/symptoms/symptom/text(),", ")}
    </p>
    <p>
    Treatments: {fn:string-join($ill/treatments/treatment/text(),", ")}
    </p>
    <p>
    Other names: {fn:string-join($ill/names/common-name/text(),", ")}
    </p>
    <p>[<a href="">Edit</a>]</p>
</div> 


};

