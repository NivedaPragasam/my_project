**free
ctl-opt dftactgrp(*no);

dcl-pi *n msg char(256); end-pi;

dsply('ERROR: ' + %trim(msg));
*inlr=*on;
return;
