**free
ctl-opt dftactgrp(*no);

dcl-pi *n item char(15) ; evt char(20); end-pi;

// This calls the HTTP client to notify downstream system
dcl-s resp varchar(1024);
resp = GET('https://notif.example.com/evt?item=' + %trim(item) + '&evt=' + %trim(evt));
dsply('Notifier response: ' + %trim(resp));

*inlr = *on; return;
