     H                    DFTACTGRP(*NO)

     C                   EVAL      *INLR = *ON

     /FREE
     // Called by other programs to centralize SQL transaction control
     dcl-proc BEGIN_TX;
       exec sql set option commit=*none;
     end-proc;

     dcl-proc COMMIT_TX;
       exec sql commit;
     end-proc;

     dcl-proc ROLLBACK_TX;
       exec sql rollback;
     end-proc;

     return;
     /END-FREE
