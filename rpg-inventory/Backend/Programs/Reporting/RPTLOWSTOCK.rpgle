**free
ctl-opt dftactgrp(*no) option(*srcstmt);


exec sql
  declare c1 cursor for
    select ITEMNO, ITMDESC, QOH
      from MYLIB.ITEMMAS
     where QOH <= REORDER;   // original view logic

exec sql open c1;

dcl-s itemno   char(15);
dcl-s desc     char(50);
dcl-s qoh      packed(9:0);

dow 1 = 1;
  exec sql fetch c1 into :itemno, :desc, :qoh;
  if sqlstate = '02000';   // no more rows
    leave;
  endif;

  dsply ('LOW STOCK: ' + %trim(itemno) +
         ' - ' + %trim(desc) +
         ' Qty=' + %char(qoh));
enddo;

exec sql close c1;

dsply ('Low stock report done');

*inlr = *on;
return;
