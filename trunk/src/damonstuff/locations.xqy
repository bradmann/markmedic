(: LOCATIONS:)
xquery version "1.0-ml";

let $locations:=
  <locations>
      <location type="zip" n="7">20190</location>  <!-- reston, VA -->
      <location type="zip" n="8">20191</location>  
      <location type="zip" n="10">20194</location> 
      <location type="city" n="4">Reston, VA</location>
      <location type="city" n="5">Vienna, VA</location>
      <location type="zip">20902</location>  <!-- sil spr, MD -->
      <location type="zip" n="33">20190</location>  <!-- reston, VA -->
      <location type="zip" n="38">20191</location>  
      <location type="zip" n="27">20194</location>  
      <location type="zip" n="6">20193</location>  
      <location type="zip" n="8">22101</location>  <!-- mclean va -->
      <location type="zip" n="15">22102</location>  
      <location type="zip" n="2">22103</location>  
      <location type="zip" n="2">20902</location>  <!-- sil spr, MD -->
      <location type="zip" n="1">20910</location>  
      <location type="zip" n="15">20911</location>  
      <location type="zip" n="55">20190</location>  <!-- reston, VA -->
      <location type="zip" n="100">20191</location>  
      <location type="zip" n="35">20194</location>  
      <location type="zip" n="100">20193</location>  
      <location type="zip" n="18">22101</location>  <!-- mclean va -->
      <location type="zip" n="30">22102</location>  
      <location type="zip" n="30">22103</location>  
      <location type="zip" n="30">20902</location>  <!-- sil spr, MD -->
      <location type="zip" n="30">20910</location>  
      <location type="zip" n="30">20911</location>  
      <location type="zip" n="200">20190</location>  <!-- reston, VA -->
      <location type="zip" n="300">20191</location>  
      <location type="zip" n="55">20194</location>  
      <location type="zip" n="100">20193</location>  
      <location type="zip" n="44">22101</location>  <!-- mclean va -->
      <location type="zip" n="66">22102</location>  
      <location type="zip" n="77">22103</location>  
      <location type="zip" n="30">20902</location>  <!-- sil spr, MD -->
      <location type="zip" n="100">20910</location>  
      <location type="zip" n="22">20911</location>  
      <location type="zip" n="20">20190</location>  <!-- reston, VA -->
      <location type="zip" n="50">20191</location>  
      <location type="zip" n="22">20194</location>  
      <location type="zip" n="88">20193</location>  
      <location type="zip" n="7">22101</location>  <!-- mclean va -->
      <location type="zip" n="18">22102</location>  
      <location type="zip" n="22">22103</location>  
      <location type="zip" n="30">20902</location>  <!-- sil spr, MD -->
      <location type="zip" n="44">20910</location>  
      <location type="zip" n="2">20911</location>  
    </locations>

let $INS := xdmp:document-insert("/templates/locations.xml", $locations)


return "inserted location docs"
