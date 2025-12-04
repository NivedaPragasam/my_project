**free
ctl-opt dftactgrp(*no);

dcl-pr GET extpgm('HTTP_CLIENT'); end-pr;

dcl-pi *n invno char(10); end-pi;

dcl-s resp varchar(1024);
resp = GET('https://api.example.com/notify?inv=' + %trim(invno));

dsply('Service responded: ' + %trim(resp));
*inlr=*on; return;
