**free
ctl-opt dftactgrp(*no) actgrp(*new) option(*srcstmt);

dcl-pr INVAUD extpgm('INVAUD'); end-pr;
dcl-pi *n invno char(10); end-pi;

exec sql
   declare c1 cursor for
     select ITEMNO, QTY from INVDET where INVNO = :invno;

exec sql
   open c1;

exec sql
   fetch from c1;

 // pretend updates, commit example
 exec sql
   update ITEMMAS set QOH = QOH + 0 where ITEMNO = 'NONE';

 exec sql
   commit;

INVAUD(invno);

*inlr = *on;
return;
