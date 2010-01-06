xquery version "1.0-ml";
module namespace person = "http://marklogic.com/person";

declare function person:make-person($illnessDoc as node()) as node()
{
<person>
	<biography/>	
	{person:get-medical($illnessDoc)}
</person>
};

declare function person:get-medical($illnessDoc as node()) as element(medical)
{
<medical>
        <history>Free Text</history>
        <vaccinations>
            <vaccination>
                <vac-date>Date</vac-date>
                <vac-targets>
                    <vac-target>Illness reference text</vac-target>
                </vac-targets>
            </vaccination>
        </vaccinations>
        <illness-reports>
            {person:get-illnesses($illnessDoc//symptom,$illnessDoc//date,person:get-enddate($illnessDoc//date, "P1D"))}
        </illness-reports>
    </medical>
};

declare function person:get-illnesses($symptoms as element()*, $startDate as xs:dateTime, $endDate as xs:date) as element()*
{
<illness-report>
                <illness-start-date>{$startDate cast as xs:date}</illness-start-date>
                <illness-end-date>{$endDate}</illness-end-date>
                <illness-certainty>1 to 100</illness-certainty>
                <illness-target>Reference</illness-target>
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