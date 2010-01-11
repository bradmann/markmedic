module namespace illmod = 'http://www.example.com/illness-model';

import module namespace search =
"http://marklogic.com/appservices/search"
at "/MarkLogic/appservices/search/search.xqy";


declare function illmod:query-from-string($searchString as xs:string?) as cts:query {
        let $terms := fn:tokenize(fn:normalize-space($searchString), " ")
        let $query := cts:and-query(
            for $term in $terms
            return
                 cts:word-query($term)
        )
        return
        $query
};

declare function illmod:search-illness($searchString as xs:string?) as element(illness)* {

    if(fn:string-length(fn:normalize-space($searchString)) > 0) then

        let $query := illmod:query-from-string($searchString)
        let $log := xdmp:log(xdmp:quote($query))
        return
        
        cts:search( xdmp:directory("/illnesses/")/illness, $query)
        
    else
        
        for $ill in xdmp:directory("/illnesses/")/illness
        order by $ill/names/official-name
        return
        $ill
};

declare function illmod:get-illness-names($searchString as xs:string?)  as xs:string*  {

   

     let  $illnesses := illmod:search-illness($searchString)//official-name/text()  
    let $log := xdmp:log(fn:concat("###",fn:string-join(  $illnesses, " "))) 
     return fn:string-join(  $illnesses, " ")
        
       
     
};

declare function illmod:get-illness-articles($searchString as xs:string?)  as  element(div)*  {
    let $str := fn:tokenize(fn:normalize-space(illmod:get-illness-names($searchString) ), ' ') 

    
    
    let $results := search:search($searchString, 

    
    <options xmlns="http://marklogic.com/appservices/search">
      <additional-query>{cts:collection-query("articles")}
      </additional-query>
    </options>, 1, 2)
    
   
    
    for $result in $results//search:result
    let $uri:= $result/@uri
    let $doc:= fn:doc($uri)
    let $title:=$doc/Article/title/text()
    let $url:=$doc/Article/url/text()
    let $snippet :=$result/search:snippet/search:match
    let $date := $doc/Article/date/text()
    let $summary := $doc/Article/summary/text()
    
    return
    <div class="article">
      <div class="articletitle">{$title}</div>
      <div class="articlesnippet">{$summary}&nbsp;<a href="{$url}">more</a></div>
      <div class="articledate">{$date}</div>
    </div> 
   
};