     H                    DFTACTGRP(*NO) ACTGRP(*CALLER)

     D INVVAL         PR                  0B 0
     D  INVNO                  10A

     D INVPRT         PR                  0B 0
     D  INVNO                  10A

     C     *ENTRY        PLIST
     C                   PARM                    INVNO

     /FREE
        // decision node example
        if invno = *blanks;
          dsply 'No invoice entered';
        else;
          // call validation (fixed program)
          CALLP     INVVAL(INVNO);
          // deeper checks
          CALLP     INVCHK(INVNO);
          // print
          CALLP     INVPRT(INVNO);
        endif;
        *inlr = *on;
        return;
     /END-FREE
