     H                    DFTACTGRP(*NO)

     FCUSTUI     CF   E             WORKSTN

     D CUSTSEARCH     PR                  0B 0
     D  custno                 10A

     C     *ENTRY        PLIST
     C                   PARM                    CUSTNO       10

     /FREE
        exfmt CUSTUI;
        if CUSTNO <> *blanks;
           callp CUSTLOOK(CUSTNO);
        endif;
        *inlr=*on; return;
     /END-FREE
