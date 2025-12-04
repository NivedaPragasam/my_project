     H                    DFTACTGRP(*NO)

     FCYCLEUI    CF   E             WORKSTN

     D GENCC         PR                  0B 0
     D  locno                   10A

     C     *ENTRY        PLIST
     C                   PARM                    LOCNO        10

     C                   EXFMT     CYCLECNT
     C                   IF        LOCNO <> *BLANKS
     C                   CALL      'CYCLECNTGEN' LOCNO
     C                   ENDIF
     C                   SETON                   LR
