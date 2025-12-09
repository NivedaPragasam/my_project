**FREE
ctl-opt dftactgrp(*NO) actgrp(*NEW) option(*SRCSTMT:*NODEBUGIO);

/INCLUDE QRPGLESRC,MYCONSTANTS
/include INVENTLIB/QRPGLEINC,ITEMSPDS

ctl-opt dftactgrp(*NO) actgrp(*CALLER);

/* Variables */
dcl-s orderId char(12) inz('ORD123456789');

/* Call external procedure defined in MYPROTOTYPES */
callp ProcessOrder(orderId);

*inlr = *on;
return;
