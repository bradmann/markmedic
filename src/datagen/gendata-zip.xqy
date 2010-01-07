declare namespace xhtml = "http://www.w3.org/1999/xhtml";

let $masterziplist :=

let $pages := (xdmp:tidy(xdmp:http-get('http://www.city-data.com/zipDir.html')[2])[2])//xhtml:a[fn:contains(@href,'zipdir/')]/@href
for $page in $pages
return

let $zips:= (xdmp:tidy(xdmp:http-get( fn:concat('http://www.city-data.com',$page) )[2])[2])//xhtml:a[fn:contains(@href,'/zips/')]/text()
for $zip in $zips
return
fn:tokenize($zip," ")[1]

return
for $z at $x in $masterziplist
return
xdmp:document-insert(fn:concat('/datagen/',$x,'.xml'),<location type="zip">{$z}</location> )
