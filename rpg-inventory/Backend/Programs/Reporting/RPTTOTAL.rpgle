**free
ctl-opt dftactgrp(*no) option(*srcstmt);

exec sql
  select sum(amount) into ::total from MYLIB.INVHDR;

dsply('Total amount = ' + %char(total));
*inlr=*on;
return;
