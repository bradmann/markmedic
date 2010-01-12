module namespace illview = 'http://www.example.com/illness-view';

import module namespace illmod = 'http://www.example.com/illness-model' at "/model/illness-model.xqy";


declare function illview:search-link($items as xs:string* , $oldText as xs:string)  {

for $newText at $x in $items
let $link := fn:concat( fn:encode-for-uri( $oldText)," ",fn:encode-for-uri($newText))
let $a := if ($x=0) then <a class="illness_title" normal_name="{fn:replace($newText, " ", "_")}" href="javascript:void(0)">{$newText}</a> else <a href="/index.xqy?illness-search-term={$link}">{$newText}</a>
return 
    if ($x = fn:count($items)) then $a else ($a, ", ")
};




declare function illview:searchIllness($searchString as xs:string?) as element(div)*{


    let $illnesses := illmod:search-illness($searchString)
    
    return
    
    for $ill in $illnesses 
    let $illcount := fn:count( cts:search(/person, 
                cts:element-value-query(
                    xs:QName("illness-target"), 
                    $ill//official-name/text()   )  ))
                    
    let $panel := 
        <div>
            <p>
            <b><a href="javascript:void(0)" class="illness_title" normal_name="{fn:replace($ill/names/official-name/text(), " ", "_")}">{$ill/names/official-name/text()}</a></b> ({$illcount})
            </p>
            <div id="{fn:replace($ill/names/official-name/text(), " ", "_")}_panel" class="slide_panel">
                <p>
                {$ill/description/text()}
                </p>
                <p>
                Symptoms: { illview:search-link($ill/symptoms/symptom/text(),$searchString) }
                </p>
                <p>
                Treatments: {illview:search-link($ill/treatments/treatment/text(),$searchString)}
                </p>
                <p>
                Other names: {fn:string-join($ill/names/common-name/text(),", ")}
                </p>
                <p>[<a href="/templates/illness-control.xqy?uri={xdmp:node-uri($ill)}">Edit</a>]</p>
                <p>&nbsp;</p>
            </div>
        </div> 
        
    return cts:highlight($panel, illmod:query-from-string($searchString), <span class="highlight">{$cts:text}</span>)

};

declare function illview:getRelatedArtices($searchString as xs:string?, $start as xs:integer?, $count as xs:integer?)  as element()* {
<div>
{
     illmod:get-illness-articles($searchString, $start, $count)
}

</div>

};
