let $locations := xdmp:directory('/datagen/')
let $loc-count := (fn:count($locations) -1)
return

for $x in (1 to 300)
return
let $rand := ( xdmp:random($loc-count) +1 )
let $ill :=
<illness name="bad cold">
    <age>{(xdmp:random(99)+1)}</age>
    <date>2009-12-16T14:18:18.309-05:00</date>
    {  ($locations) [$rand]  }
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
