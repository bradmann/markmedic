module namespace illmod = 'http://www.example.com/illness-model';

declare function illmod:search-illness($searchString as xs:string?) as element(illness)* {

     let $log := xdmp:log(fn:concat("Model: term is : '",$searchString,"'")) 
    return
    
    if(fn:string-length(fn:normalize-space($searchString)) > 0) then

        let $terms := fn:tokenize(fn:normalize-space($searchString), " ")
        
        let $query := cts:and-query(
            for $term in $terms
            return
                 cts:word-query($term)
        )
        let $log := xdmp:log(xdmp:quote($query))
        return
        
        cts:search( xdmp:directory("/illnesses/")/illness, $query)
        
    else
        
        
        
        xdmp:directory("/illnesses/")/illness


};

