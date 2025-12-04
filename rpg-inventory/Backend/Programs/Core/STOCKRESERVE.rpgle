     H                    DFTACTGRP(*NO)

     D ITEMNO        S            15A
     D REQQTY        S             9P 3

     C     *ENTRY        PLIST
     C                   PARM                    ITEMNO       15
     C                   PARM                    REQQTY       9  3

     /FREE
       // start Pseudo-transaction using SQL
       exec sql set option commit=*none;
       exec sql update MYLIB.ITEMMAS set QOH = QOH - :REQQTY where ITEMNO = :ITEMNO;
       if sqlcode <> 0;
          exec sql rollback;
          callp LOGERR('Reserve failed for:' + %trim(ITEMNO));
          return;
       endif;
       exec sql commit;
       dsply('Reserved ' + %char(REQQTY) + ' of ' + %trim(ITEMNO));
       *inlr = *on; return;
     /END-FREE
