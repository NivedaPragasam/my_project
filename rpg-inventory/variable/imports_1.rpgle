**FREE
ctl-opt dftactgrp(*NO) actgrp(*NEW) option(*SRCSTMT:*NODEBUGIO);

/include INVENTLIB/QRPGLEINC,ITEMSPDS
// Modern Include (preferred for ILE RPG)

/COPY INVENTLIB/QRPGLEINC,ITEMSPDS
// Classic Include (still supported in SEU)

dow not %eof(ITEMS);

   dsply ('Item: ' + %char(ITEMID) + '  ' + %trim(ITEMNAME)
          + ' Stock=' + %editc(QTYONHAND:'J'));

   read ITEMS ItemDS;
enddo;

*inlr = *on;
Return;