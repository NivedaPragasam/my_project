**FREE
ctl-opt dftactgrp(*NO) actgrp(*NEW) option(*SRCSTMT:*NODEBUGIO)
        main(Main);

 /copy QRPGLESRC,TRNREPT_H  // Prototypes included below

// ---------------------------
// FILE SPECS
// ---------------------------
fTRANSDET  IF   E           K DISK
fTRLNIDX   IF   E           K DISK           // Logical file
fTRNREPTF  O    E             PRINTER        // Printer file
fTRNREPTD  CF   E             WORKSTN        // Display file

// ---------------------------
// GLOBAL VARIABLES
// ---------------------------
dcl-s ItemID     packed(5:0);
dcl-s LocID      char(5);
dcl-s Qty        packed(9:0);
dcl-s TrnType    char(1);
dcl-s TrnNo      packed(7:0);
dcl-s ErrorFlag  ind;

// ---------------------------
// MAIN PROCEDURE
// ---------------------------
dcl-proc Main;
   monitor;
      exsr $Initialize;

      dou *in03;
         exfmt SELSCRN;

         if *in05;
            exsr $StartCommitment;
            exsr $GenerateReport;
            exsr $EndCommitment;
         endif;

      enddo;

   on-error;
      exsr $RollbackCommitment;
   endmon;

   *inlr = *on;
end-proc;

// ---------------------------
// SUBROUTINE: Initialize
// ---------------------------
begsr $Initialize;
   ItemID = 0;
   LocID = *blanks;
   Qty = 0;
   ErrorFlag = *off;
endsr;

// ---------------------------
// SUBROUTINE: Begin Commitment Control
// ---------------------------
begsr $StartCommitment;
   exec sql set option commit = *CS;   // Change to native mode below
   commit;                             // Start a new transaction block
endsr;

// ---------------------------
// SUBROUTINE: Rollback
// ---------------------------
begsr $RollbackCommitment;
   rollback;
endsr;

// ---------------------------
// SUBROUTINE: End Commitment Control
// ---------------------------
begsr $EndCommitment;
   commit;
endsr;

// ---------------------------
// SUBROUTINE: Generate the report
// ---------------------------
begsr $GenerateReport;

   // Print header
   HDTXT = 'DETAILED TRANSACTION REPORT';
   except HDR1;

   // Use Logical File for filtering
   setll ItemID TRLNIDX;
   reade ItemID TRLNIDX;

   dow not %eof(TRLNIDX);

      // Load detail record
      Item     = %char(ITEMID);
      Loc      = LOCID;
      Qty      = QTY;
      TrnType  = TRNTYPE;
      TrnNo    = TRNID;

      except DETAIL;

      reade ItemID TRLNIDX;

   enddo;

endsr;

// ---------------------------
// Prototype Copy Member
// ---------------------------
**END-FREE
