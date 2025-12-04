**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f INVHDR keyed usage(*input);
dcl-f INVDET keyed usage(*input);

dcl-pi *n invno char(10); end-pi;

if %trim(invno) = *blanks;
  dsply('No invoice specified');
  *inlr = *on; return;
endif;

chain invno INVHDR;
if not %found(INVHDR);
  dsply('Invoice not found: ' + %trim(invno));
  *inlr = *on; return;
endif;

// show header
dsply('Invoice: ' + %trim(invno) + ' Amount:' + %char(AMOUNT));

// list lines
setll invno INVDET;
reade invno INVDET;
dow %found;
  dsply('Line: ' + %trim(ITEMNO) + ' Qty:' + %char(QTY));
  reade invno INVDET;
enddo;

*inlr = *on;
return;
