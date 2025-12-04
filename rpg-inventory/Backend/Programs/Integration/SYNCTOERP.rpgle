     H                    DFTACTGRP(*NO)

     C     *ENTRY        PLIST
     C                   PARM                    INVNO         10

     /FREE
        dcl-s resp varchar(1024);
        resp = GET('https://api.example.com/sync?inv=' + %trim(invno));
        if %scan('error': resp) > 0;
          CALLP LOGERR('ERP sync failed: ' + %trim(resp));
        else;
          dsply('ERP sync OK: ' + %trim(resp));
        endif;
        *inlr=*on; return;
     /END-FREE
