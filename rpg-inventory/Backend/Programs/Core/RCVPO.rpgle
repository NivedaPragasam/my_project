**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f PURCHORD keyed;
dcl-f PURCHITEM keyed;
dcl-f ITEMMAS keyed;
dcl-f INVTRN keyed;

dcl-pi *n pono char(12); end-pi;

chain pono PURCHORD;
if not %found; dsply('PO not found'); *inlr=*on; return; endif;

setll pono PURCHITEM;
reade pono PURCHITEM;
dow %found(PURCHITEM);
  itemno = ITEMNO;
  chain itemno ITEMMAS;
  if %found(ITEMMAS);
    QOH = QOH + QTY;
    update ITEMMSTR;
  endif;
  // write transaction
  TRNNO = 'TR' + %char(%timestamp():*iso);
  ITEMNO = itemno; TRNTYPE = 'IN'; QTY = QTY; TRNDATE = %char(%date()); REFNO = pono;
  write INVTRNR;
  reade pono PURCHITEM;
enddo;

STATUS = 'R';
update POHDR;

dsply('PO received ' + pono);
*inlr = *on; return;
