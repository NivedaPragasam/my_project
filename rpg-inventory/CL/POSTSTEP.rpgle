**FREE
// Program: POSTSTEP
// Purpose: Demo program with parameter &CUST, IF condition, and a DB call (embedded SQL).
// Notes:
//   - Replace library/table names to match your environment.
//   - Ensure the program is created with the correct binding and commitment settings.

// ---------- Prototypes / Parameters ----------
// Entry parameter
// Using free-form RPG, define program interface (PI) for the entry parameter.
dcl-pi *n;
   Cust char(10);
end-pi;

// ---------- Working variables ----------
dcl-s CustName varchar(50);
dcl-s Status   char(1)   inz('N');
dcl-s ErrMsg   varchar(128);

// ---------- SQL setup ----------
// Use commitment control as needed (change to *none if not required)
exec sql set option commit = *none, naming = *sys, datfmt = *iso;

// ---------- Basic validation ----------
// IF condition: check the parameter and proceed only if present.
if %trim(Cust) = '';
   ErrMsg = 'Customer parameter is required.';
   dsply ErrMsg;
   return;
endif;

// ---------- DB call (embedded SQL) ----------
// Example: fetch a customer's name from a table. Adjust schema and column names.
// Replace MYLIB.CUSTOMER with your actual library and table.
exec sql
   select NAME
     into :CustName
     from MYLIB.CUSTOMER
    where CUSTNO = :Cust;

// Check SQL status using SQLSTATE
if sqlstate <> '00000';
   // Not found or error
   if sqlstate = '02000';
      ErrMsg = 'Customer not found: ' + %trim(Cust);
   else;
      ErrMsg = 'SQL error. SQLSTATE=' + sqlstate;
   endif;
   dsply ErrMsg;
   return;
endif;

// ---------- Business logic ----------
// Another IF condition example using the fetched data
if %len(%trim(CustName)) > 0;
   Status = 'Y';
   dsply ('Customer ' + %trim(Cust) + ' -> ' + %trim(CustName));
else;
   Status = 'N';
   dsply ('Customer name missing for ' + %trim(Cust));
endif;

// ---------- End program ----------
*inlr = *on;
return;
