     H                    DFTACTGRP(*NO)

     D TRNNO         S            12A

     C     *ENTRY        PLIST
     C                   PARM                    TRNNO

     /FREE
       TRNNO = %trim(TRNNO);
       // Write a lightweight audit into INVTRN (reuse fields)
       ITEMNO = 'AUDIT'; QTY = 0; TRNTYPE = 'ADT'; TRNDATE = %char(%date());
       write INVTRNR;
       *inlr = *on; return;
     /END-FREE
