xquery version "1.0-ml";

for $art at $i in doc("/news/reuters.xml")/objects/Article
let $uri := fn:concat("/news/", fn:encode-for-uri($art/url), $i, ".xml")
return xdmp:document-insert($uri, $art, (), ("articles"))
