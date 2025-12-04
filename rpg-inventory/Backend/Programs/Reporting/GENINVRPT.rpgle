**free
ctl-opt dftactgrp(*no);

dcl-f INVHDR keyed;
setll *start INVHDR;
reade *start INVHDR;
dow %found;
  write PRTINV;
  reade *start INVHDR;
enddo;
*inlr=*on; return;
