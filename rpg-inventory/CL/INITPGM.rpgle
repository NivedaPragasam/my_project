ctl-opt dftactgrp(*no) actgrp(*caller) option(*srcstmt:*nodebugio);
dcl-pi *n;
  cust char(10) const;
  env  char(10) const;
end-pi;

/FREE
   *INLR = *OFF;

   EXSR $INIT;

   DOU *IN03 = *ON;

      EXFMT ITEMSCRN;

      IF *IN05 = *ON;     // ADD
         EXSR $ADD;
      ELSEIF *IN06 = *ON; // UPDATE
         EXSR $CHG;
      ELSEIF *IN12 = *ON; // DELETE
         EXSR $DEL;
      ELSE;
         EXSR $LOAD;     // Load record for display
      ENDIF;

   ENDDO;

   *INLR = *ON;
   RETURN;
 /END-FREE
call 'INVENTLIB/orch';


*inlr = *on;


