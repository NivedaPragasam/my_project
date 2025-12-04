**free
ctl-opt dftactgrp(*no);

dcl-f CUSTMR keyed;
setll *start CUSTMR;
reade *start CUSTMR;
dow %found;
  write PRTSUP; // reuse PRTSUPP or appropriate printer
  reade *start CUSTMR;
enddo;
*inlr=*on; return;
