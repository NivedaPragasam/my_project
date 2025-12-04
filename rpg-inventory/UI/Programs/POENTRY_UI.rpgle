     H                    DFTACTGRP(*NO)

     FPOENTRY    CF   E             WORKSTN

     D POENTRY         PR                  0B 0
     D  pono                    12A

     C     *ENTRY        PLIST
     C                   PARM                    PONO         12

     /FREE
        // simple UI-read pattern
        exfmt POENTRY;
        if PONO <> *blanks;
           callp POENTRY(PONO);
        endif;
        *inlr = *on; return;
     /END-FREE
