     H                    DFTACTGRP(*NO)

     D GENINVLIST     PR                  0B 0

     C     *ENTRY        PLIST
     C                   PARM                    OPTION       1A

     /FREE
        // call generator and print driver
        CALLP     GENINVLIST();
        CALLP     INVPRT('ALL');
        *inlr = *on;
        return;
     /END-FREE
