**free
ctl-opt dftactgrp(*no);

dcl-f INVHDR keyed;
dcl-s cnt int(10) inz(0);

setll *start INVHDR;
reade *start INVHDR;
dow %found;
  cnt += 1;
  reade *start INVHDR;
enddo;
dsply('Invoices total: ' + %char(cnt));
*inlr=*on;
return;
