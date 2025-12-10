**FREE
ctl-opt dftactgrp(*no) actgrp('TAXAG') option(*srcstmt:*noDebugIO);

// File: TAXCALCulate.rpgle
// Purpose: Procedure TAXCALC callable via CL: CALLPRC PRC('TAXCALC') PARM(&AMT)
//          Adds tiered tax calculation, rounding, and IF-based conditions.
// Behavior: Receives &AMT (packed 15,2). Computes tax with slabs:
//   - amt <= 0       : tax = 0 (and display warning)
//   - 0 < amt < 100  : 5%
//   - 100 <= amt <= 1000 : 12%
//   - amt > 1000     : 18%
//   Additionally, if amt > 5000, apply health & education cess 4% on tax.
//   Rounds tax to 2 decimals (bankers rounding via %round is not available; uses %dec).
// Returns: Overwrites &AMT with the computed TAX amount.
// Notes:
//   - To return TOTAL (amount + tax), change the assignment to: amt = amt + tax;
//   - Adjust slab rates and thresholds to your business rules.

// ---------- Constants ----------
dcl-c RATE_LOW     const(0.05);
dcl-c RATE_MID     const(0.12);
dcl-c RATE_HIGH    const(0.18);
dcl-c CESS_RATE    const(0.04);   // 4% cess on tax when amt > 5000

// ---------- Prototype (exported) ----------
dcl-pr TAXCALC extproc(*export);
   amt packed(15:2);
end-pr;

// ---------- Procedure implementation ----------
dcl-proc TAXCALC export;
   dcl-pi *n;
      amt packed(15:2);
   end-pi;

   dcl-s tax       packed(15:2) inz(0);
   dcl-s baseRate  packed(5:3)  inz(0);
   dcl-s cess      packed(15:2) inz(0);
   dcl-s msg       varchar(80);

   // ---------- Validation IFs ----------
   if amt <= 0;
      msg = 'Amount is non-positive. Tax set to 0.';
      dsply msg;
      amt = 0;
      return;
   endif;

   // ---------- Slab selection ----------
   if amt < 100;
      baseRate = RATE_LOW;
   elseif amt <= 1000;
      baseRate = RATE_MID;
   else;
      baseRate = RATE_HIGH;
   endif;

   // Compute base tax
   tax = %dec(%float(amt) * %float(baseRate): 15: 2);

   // ---------- Additional IF: apply cess for large amounts ----------
   if amt > 5000;
      cess = %dec(%float(tax) * CESS_RATE: 15: 2);
      tax = tax + cess;
   endif;

   // ---------- Display info (optional) ----------
   // Uncomment the following line if you want runtime info on slabs applied
   // dsply ('Rate=' + %char(baseRate) + ' Cess=' + %char(cess));

   // ---------- Return value ----------
   // Overwrite input param with computed TAX
   amt = tax;

   // If you prefer to return TOTAL (amount + tax), use:
   // amt = amt + tax;

end-proc;

*inlr = *on;
