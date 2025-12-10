**free
ctl-opt dftactgrp(*no) actgrp(*new) option(*srcstmt);

dcl-f ITEMMAS keyed usage(*update);
dcl-f SALESITEM keyed usage(*update);
dcl-pi *n sono char(12); end-pi;

// Level 1: entry from ORDENTRY
// Level 2: reserve items (this proc)
// Level 3: on low stock, call NOTIFY

setll sono SALESITEM;
reade sono SALESITEM;
dow %found(SALESITEM);
  // check QOH
  itemno = ITEMNO;
  chain itemno ITEMMAS;
  if %found(ITEMMAS);
    if QOH < QTY;
      // call notifier - level 3
      callp ASYNC_NOTIFIER(itemno : 'LOW_STOCK');
    else;
      QOH = QOH - QTY;
      update ITEMMSTR;
    endif;
  endif;
  reade sono SALESITEM;
enddo;

*inlr = *on;
return;
