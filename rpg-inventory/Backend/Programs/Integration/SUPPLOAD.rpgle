**free
ctl-opt dftactgrp(*no) option(*srcstmt);

dcl-f SUPPLR keyed;

exec sql set option commit=*none;

 // pretend insert
 exec sql insert into MYLIB.SUPPLR (SUPPNO, SUPPNAME, STATUS) values ('S100','Acme','A');
 if sqlcode <> 0;
   exec sql rollback;
   return;
 endif;

 exec sql commit;

 dsply('Supplier loaded and committed');
 *inlr=*on; return;
