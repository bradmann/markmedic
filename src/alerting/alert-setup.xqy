(: run this a user with the alert-admin role :)
xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" 
          at "/MarkLogic/alert.xqy";

let $config := alert:make-config(
      "/alert/alert-config.xml",
      "MarkMedic Alerting",
      "Alerting config for my app",
        <alert:options/> )
return
alert:config-insert($config);


(: ------------------ :)


xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" 
          at "/MarkLogic/alert.xqy";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
      at "/MarkLogic/admin.xqy";
    
  let $config := admin:get-configuration()
  let $mod-db-id :=  admin:database-get-id($config, "medic-cpf-modules")


let $action := alert:make-action(
    "xdmp:log", 
    "log to ErrorLog.txt",
    $mod-db-id,
    "/", 
    "/alerts/alert-action.xqy",
    <alert:options>put anything here</alert:options> )
return
alert:action-insert("/alert/alert-config.xml", $action);




xquery version "1.0-ml";
import module namespace alert = "http://marklogic.com/xdmp/alert" 
          at "/MarkLogic/alert.xqy";

let $rule := alert:make-rule(
    "Simple Search Rule", 
    "Simple Search Rule",
    0, (: equivalent to xdmp:user(xdmp:get-current-user()) :)
    cts:word-query("H1N1"),
    "xdmp:log",
    <alert:options/> )
return
alert:rule-insert("/alert/alert-config.xml", $rule);



 xquery version "1.0-ml";
  import module namespace alert = "http://marklogic.com/xdmp/alert" 
          at "/MarkLogic/alert.xqy";
  import module namespace trgr="http://marklogic.com/xdmp/triggers" at "/MarkLogic/triggers.xqy";

  let $uri := "/alert/alert-config.xml"
  let $trigger-ids :=
    alert:create-triggers (
        $uri,
        trgr:trigger-data-event(
            trgr:directory-scope("/output/", "infinity"),
            trgr:document-content(("create", "modify")),
            trgr:post-commit()))
  let $config := alert:config-get($uri)
  let $new-config := alert:config-set-trigger-ids($config, $trigger-ids)
  return alert:config-insert($new-config)


