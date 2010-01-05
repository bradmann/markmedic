(: TEMPLATES :)
xquery version "1.0-ml";


let $cold := 
  <template>
    <user-names><name>cough</name><name>cold</name><name>bad cold</name></user-names>
    <symptom>
      <type>sore throat</type> 
      <when start = "4" duration="2"/>
      <severity>5</severity>
    </symptom>
    <symptom>
      <type>cough<qualifier>dry</qualifier><qualifier>hacking</qualifier></type> 
      <when start = "1" duration="2"/>
      <severity>2</severity>
    </symptom>
    <symptom>
      <type>runny nose</type> 
      <when start = "3" duration="6"/>
      <severity>4</severity>
    </symptom>
     <symptom>
      <type>tired</type> 
      <when start = "2" duration="5"/>
    </symptom>
    <overall-duration>9</overall-duration>
  </template>
let $INS := xdmp:document-insert("/templates/cold.xml", $cold)

let $flu := 
  <template>
    <user-names><name>flu</name><name>flu</name><name>flu</name><name>influenza</name><name>H1N1</name><name>H1N1</name><name>H1 N1</name><name>h1n1</name><name>swine flu</name></user-names>
    <symptom>
      <type>sore throat</type> 
      <when start = "1" duration="3"/>
      <severity>3</severity>
    </symptom>
    <symptom>
      <type>aches<qualifier>body</qualifier></type> 
      <when start = "3" duration="6"/>
      <severity>2</severity>
    </symptom>
    <symptom>
      <type>vomiting</type> 
      <when start = "2" duration="2"/>
      <severity>5</severity>
    </symptom>
     <symptom>
      <type>tired</type> 
      <when start = "2" duration="10"/>
    </symptom>
    <overall-duration>10</overall-duration>
  </template>
let $INS := xdmp:document-insert("/templates/flu.xml", $flu)

let $allergy := 
  <template>
    <user-names><name>hay fever</name><name>hay fever</name><name>hay fever</name><name>hay fever</name><name>hay fever</name><name>allergies</name></user-names>
    <symptom>
      <type>sore throat</type> 
      <when start = "1" duration="50"/>
      <severity>2</severity>
    </symptom>
    <symptom>
      <type>itchy eyes</type> 
      <when start = "1" duration="100"/>
      <severity>4</severity>
    </symptom>
    <symptom>
      <type>runny nose</type> 
      <when start = "4" duration="999"/>
      <severity>5</severity>
    </symptom>
    <overall-duration>100</overall-duration>
  </template>
let $INS := xdmp:document-insert("/templates/allergy .xml", $allergy )

return "inserted templates"