**free
ctl-opt dftactgrp(*no) actgrp(*new) option(*srcstmt);

dcl-f INVHDR keyed;

dcl-pi *n invno char(10); newamt packed(15:2); end-pi;

exec sql
  set option commit=*none;

beginRoutine:
  exec sql
    update MYLIB.INVHDR set AMOUNT = :newamt where INVNO = :invno;
  if sqlcode <> 0;
     exec sql rollback;
     dsply('Update failed; rollback performed');
     return;
  endif;

  exec sql commit;
  dsply('Update committed');

*inlr = *on;
return;
