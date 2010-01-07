xquery version "1.0-ml";

for $uri in cts:uris()
return
  if (fn:matches($uri, "/output/.+")) then 
     ("person: ", $uri, xdmp:document-add-collections($uri, "persons"))
  else if (fn:matches($uri, "/illnesses/.+")) then 
     ("illness: ", $uri, xdmp:document-add-collections($uri, "illnesses"))
  else ()