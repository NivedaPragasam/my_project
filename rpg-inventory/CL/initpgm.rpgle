** Simple skeleton for INITPGM
** Receives two parameters: customer and environment (char 10 each)
** Replace body with real logic.

ctl-opt dftactgrp(*no) actgrp(*caller) option(*srcstmt:*nodebugio);

dcl-pr *n;
  cust char(10) const;
  env  char(10) const;
end-pr;

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

// TODO: implement initialization logic here
// For now, just mark LR on entry/exit.

*inlr = *on;

