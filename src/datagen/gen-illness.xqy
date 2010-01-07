let $locations := xdmp:directory('/datagen/')
let $loc-count := (fn:count($locations) -1)

let $illnesses := fn:distinct-values(   (/illness/names)/common-name[1]/text()    )
let $illness-count := (fn:count($illnesses ) -1)

return

for $x in (1 to 200)
return
let $rand-loc := ( xdmp:random($loc-count) +1 )
let $rand-illness := ( xdmp:random($illness-count) +1 )
let $ill :=
<illness name="{($illnesses) [$rand-illness]}">
    <age>{(xdmp:random(99)+1)}</age>
    <date>2009-12-16T14:18:18.309-05:00</date>
    {  ($locations) [$rand-loc]  }
    <symptom>
        <type>cough</type>
        <qualifier>dry</qualifier>
        <qualifier>hacking</qualifier>
        <when start="1" duration="2" />
        <severity>2</severity>
    </symptom>
    <symptom>
        <type>runny nose</type>
        <when start="3" duration="2" />
        <severity>3</severity>
    </symptom>
    <overall-duration>3</overall-duration>
</illness>



let $query:=fn:concat("
xdmp:document-insert( '/input/generated-",$x,".xml', ",xdmp:quote($ill)," )
"
)

return 

xdmp:eval($query)
