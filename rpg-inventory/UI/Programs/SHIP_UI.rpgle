**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f SHIPCONF workstn;

dcl-pr SHIPCONF extpgm('SHIPCONF'); end-pr;

dcl-s sono char(12);

dow not *in03;
  exfmt SHIPCONF;
  if sono <> *blanks;
    SHIPCONF(sono);
  endif;
enddo;

*inlr = *on; return;
