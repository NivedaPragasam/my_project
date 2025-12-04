**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f ORDENTRY workstn;

dcl-pr ORDENTRY extpgm('ORDENTRY'); end-pr;

dcl-s sono char(12);

dow not *in03;
  exfmt ORDENTRY;
  if sono <> *blanks;
    ORDENTRY(sono);
  endif;
enddo;

*inlr = *on; return;
