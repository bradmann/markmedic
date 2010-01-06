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
    Symptoms: {$ill/symptoms/symptom/text()}
    <br/>
    Treatments: {$ill/treatments/treatment/text()}
    <br/>
    Other names: {$ill/names/common-name/text()}
    </p>
    <p>[<a href="">Edit</a>]</p>
</div> 


};

