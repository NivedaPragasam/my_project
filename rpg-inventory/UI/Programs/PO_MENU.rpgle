**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f POMENU workstn;

dcl-pr POENTRY extpgm('POENTRY'); end-pr;
dcl-pr RCVPO_UI extpgm('RCVPO_UI'); end-pr;

dcl-s opt char(1);

dow not *in03;
  exfmt POMENU;
  select;
    when opt = '1'; POENTRY('AUTO'); // example param
    when opt = '2'; RCVPO_UI();
    when opt = '3'; leave;
  endsl;
enddo;

*inlr = *on; return;
