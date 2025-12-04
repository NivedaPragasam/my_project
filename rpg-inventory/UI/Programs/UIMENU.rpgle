     H                    DFTACTGRP(*NO) ACTGRP(*NEW)

     FMAINDSP    CF   E             WORKSTN

     D INVMAIN         PR                  0B 0
     D  parm1                 10a

     C     *ENTRY        PLIST
     C                   PARM                    OPT         1A

     /FREE
        dcl-s opt char(1);
        opt = %trim(OPT);
        select;
          when opt = '1';
            callp INVMAIN();
          when opt = '2';
            callp PO_MENU();
          when opt = '3';
            callp RPTMENU();
          when opt = '4';
            callp SUPP_MENU();
          other;
            dsply('Invalid option');
        endsl;
        *inlr = *on;
        return;
     /END-FREE
