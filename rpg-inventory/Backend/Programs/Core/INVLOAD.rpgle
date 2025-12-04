**free
ctl-opt dftactgrp(*no) actgrp(*new) option(*srcstmt);

dcl-f INVHDR keyed usage(*input);
dcl-f INVDET keyed usage(*input);

dcl-pi *n;
  invno char(10) const;
  out_cust char(10);
  out_amt  packed(15:2);
  out_stat char(1);
end-pi;

chain invno INVHDR;
if %found(INVHDR);
  out_cust = CUSTNO;
  out_amt  = AMOUNT;
  out_stat = STATUS;
else;
  out_cust = *blanks;
  out_amt  = 0;
  out_stat = ' ';
endif;

*inlr = *on;
return;
