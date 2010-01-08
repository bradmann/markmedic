xquery version "1.0-ml";
module namespace person = "http://marklogic.com/person";

import module namespace geoc = 'http://www.example.com/geocode.xqy' at '/services/geocode.xqy';
import module namespace diag = 'http://www.example.com/diagnoseIllness.xqy' at '/services/diagnoseIllness.xqy';


declare function person:make-person($illnessDoc as node()) as node()
{
<person>
	{person:get-biography($illnessDoc)}	
	{person:get-medical($illnessDoc)}
</person>
};

declare function person:get-biography($illnessDoc as node()) as element(biography) {
    let $zip := $illnessDoc//location[@type='zip']/text()
    let $city := $illnessDoc//location[@type='city']/text()
    let $geocode := 
        if($zip) then geoc:geocode-zip($zip) 
        else if($city) then geoc:geocode-zip($city) 
        else ()
    return
    <biography> 
        <dob></dob>
        <first-name>Anonymous</first-name>
        <last-name></last-name>
        <address1></address1>
        <address2></address2>
        <city>{$city}</city>
        <state></state>
        <zip>{$zip}</zip>
        <gender></gender>
        <ethnicity></ethnicity>
        {$geocode}
    </biography>
};

declare function person:get-medical($illnessDoc as node()) as element(medical)
{
<medical>
        <history></history>
        <vaccinations>
            <vaccination>
                <vac-date></vac-date>
                <vac-target></vac-target>
            </vaccination>
        </vaccinations>
        <illness-reports>
            {person:get-illnesses($illnessDoc/illness/@name, $illnessDoc//symptom,$illnessDoc//date,person:get-enddate($illnessDoc//date, "P1D"))}
        </illness-reports>
    </medical>
};

declare function person:get-illnesses($name as xs:string, $symptoms as element()*, $startDate as xs:dateTime, $endDate as xs:date) as element()*
{
let $off-name := diag:diagnose-illness-by-name($name)//official-name/text()
return

<illness-report>
                <illness-start-date>{$startDate cast as xs:date}</illness-start-date>
                <illness-end-date>{$endDate}</illness-end-date>
                <illness-certainty>1 to 100</illness-certainty>
                <illness-target>{$off-name}</illness-target>
                <illness-symptoms>
                {for $symptom in $symptoms
                    return <symptom>{$symptom/type/text()}</symptom>
                }
                </illness-symptoms>
</illness-report>
};

declare function person:get-enddate($start as xs:dateTime, $duration as xs:string) as xs:date
{
 ( $start + xs:dayTimeDuration($duration) ) cast as xs:date
};