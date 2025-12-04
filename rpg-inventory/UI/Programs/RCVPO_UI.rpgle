     H                    DFTACTGRP(*NO)

     FRCVPO      CF   E             WORKSTN

     D RCVPO         PR                  0B 0
     D  pono                    12A

     C     *ENTRY        PLIST
     C                   PARM                    PONO         12

     C                   EXFMT     RCVPO
     C                   IF        PONO <> *BLANKS
     C                   CALL      'RCVPO'       PONO
     C                   ENDIF
     C                   SETON                   LR
