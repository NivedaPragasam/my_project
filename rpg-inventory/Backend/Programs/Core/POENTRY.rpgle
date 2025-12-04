     H                    DFTACTGRP(*NO)

     D PONO          S            12A
     D SUPPNO        S            10A

     C     *ENTRY        PLIST
     C                   PARM                    PONO
     C                   PARM                    SUPPNO

     /FREE
        // simple write of PO header (assumes PF exists)
        PONO = %trim(PONO);
        SUPPNO = %trim(SUPPNO);
        write POHDR;
        // write 1 line example
        LINENO = 1; ITEMNO = 'ITEM0001'; QTY = 10; UPRICE = 12.50;
        write POITEM;
        *inlr = *on;
        return;
     /END-FREE
