**free
ctl-opt dftactgrp(*no);

dcl-s resp varchar(1024);
resp = GET('https://api.example.com/health');
dsply('Health: ' + %trim(resp));

*inlr=*on; return;
