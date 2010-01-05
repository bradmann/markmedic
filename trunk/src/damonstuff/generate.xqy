(: GENERATE :)
xquery version "1.0-ml";

declare namespace gen = "generate-illness-data";

declare private function gen:pick-one($items) {
  let $i as xs:int := xdmp:random(count($items) - 1)+1 (: random gives 0-N, so make it 1-N :)
  return $items[$i] 
};

declare private function gen:pick-most($items, $pct) {
  $items[xdmp:random(100)<$pct]
};

declare private function gen:adjust-down($n as xs:int, $adj as xs:int) as xs:int {
  let $adj2 := if ($adj lt 0) then 0 else $adj
  return  xs:int(floor($n - xdmp:random($adj2)))  (: reduce $n by at most $adj :)
};

declare private function gen:adjust-symptoms($symptoms as element(symptom)*)
    as element(symptom)* {
  for $s in $symptoms
  let $type-txt := gen:pick-one($s//type/text())
  let $qualifiers := gen:pick-most($s/type/qualifier, 60)
  let $start := gen:adjust-down($s/when/@start, xs:int($s/when/@start div 2))
  let $dur := gen:adjust-down($s/when/@duration, xs:int($s/when/@duration - 1))
  let $sev := gen:adjust-down($s/severity, xs:int($s/severity - 2) )
  return   
    element symptom { 
      element type { $type-txt }, 
      $qualifiers, 
      <when start={$start} duration={$dur}/>,
      element severity { $sev }
    }
};
  
declare function gen:generate(
      $t as element(template), $n as xs:int, 
      $age-min as xs:int, $age-max as xs:int,
      $recency as xs:int) 
  as element(illness)* {

  let $symptoms := $t//symptom
  let $user-names := $t//user-names
  let $overall-dur := $t//overall-duration
  let $locations := doc("/templates/locations.xml")/locations/location
  for $i in 1 to $n
  let $days-ago := xs:dayTimeDuration(concat("P", floor(xdmp:random($recency)), "D"))
  return
    element illness {
      attribute name {gen:pick-one($user-names/name)/text()},
      element age { $age-min + xdmp:random($age-max - $age-min) },
      element date {current-dateTime() - $days-ago},
      gen:pick-one($locations),
      gen:adjust-symptoms(gen:pick-most($symptoms, 70)),
      element overall-duration { $overall-dur div 3 + xdmp:random(xs:int(($overall-dur div 3) * 2)) }
    }
};

let $ills := 
  (
  gen:generate(doc("/templates/cold.xml")/template, 50, 2, 99, 45), 
  gen:generate(doc("/templates/flu.xml")/template, 20, 2, 12, 50),
  gen:generate(doc("/templates/flu.xml")/template, 40, 13, 55, 25),
  gen:generate(doc("/templates/flu.xml")/template, 20, 56, 80, 35),
  gen:generate(doc("/templates/allergies.xml")/template, 20, 4, 99, 15)
  )

for $ill at $i in $ills
return  xdmp:save(concat("m:/data/bootcamp/illnessData/illness_", $i, ".xml"), $ill) 
