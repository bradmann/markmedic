xquery version "1.0-ml";

let $uri := try { xdmp:unquote(xdmp:get-request-field("uri")) } catch($e) { xdmp:get-request-field("uri",()) }
return
if($uri) then
    let $person := doc($uri)/person
    let $name := fn:concat($person/biography/first-name/text()," ",$person/biography/last-name/text())

    return
    if($person) then
        <div>
            <h3>{$name}</h3>
            <div>
                {
                for $ill in $person//illness-report/illness-target/text()
                return
                (<span>{$ill}</span>, <br/>)
                }
            </div>
        </div>
    else
        <div>Unknown</div>
else
    <div>Unknown</div>
    
   