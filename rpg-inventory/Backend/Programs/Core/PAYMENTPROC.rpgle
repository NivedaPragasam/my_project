**free
ctl-opt dftactgrp(*no);

dcl-pi *n invno char(10); end-pi;

dcl-s resp varchar(1024);
resp = GET('https://pay.example.com/process?inv=' + %trim(invno));

if %scan('OK' : resp) > 0;
   // on success, update invoice status
   exec sql update MYLIB.INVHDR set STATUS='P' where INVNO = :invno;
   exec sql commit;
   dsply('Payment success for ' + %trim(invno));
else;
   exec sql rollback;
   callp LOGERR('Payment failed: ' + %trim(resp));
endif;

*inlr = *on; return;
