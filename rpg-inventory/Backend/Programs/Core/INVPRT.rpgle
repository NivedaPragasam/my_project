     H                    DFTACTGRP(*NO)

     FPRTINV     O    F  132        PRINTER
     FINVDET    IF   E           K DISK

     C     *ENTRY        PLIST
     C                   PARM                    INVNO         10

     /FREE
        setll invno INVDET;
        reade invno INVDET;
        dow %found;
          write PRINTREC;
          reade invno INVDET;
        enddo;
        *inlr = *on;
        return;
     /END-FREE
