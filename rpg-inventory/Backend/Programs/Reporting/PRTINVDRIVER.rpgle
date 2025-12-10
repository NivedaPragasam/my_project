     H                    DFTACTGRP(*NO)

     FPRTINV     O    F  132        PRINTER

     C     *ENTRY        PLIST
     C                   PARM                    INVNO         10

     /FREE
        // Implementation similar to INVPRT
        dcl-f INVDET keyed usage(*update);
        setll invno INVDET;
        reade invno INVDET;
        dow %found;
          write PRINTREC;
          reade invno INVDET;
        enddo;
        *inlr = *on;
        return;
     /END-FREE
