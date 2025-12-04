**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-pi *n invno char(10); end-pi;

dsply ('AUDIT: invoice ' + %trim(invno) + ' logged');

*inlr = *on;
return;
