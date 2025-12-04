**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-f SUPPMENU workstn;

dcl-pr SUPPMGMT extpgm('SUPPMGMT'); end-pr;

dcl-s suppno char(10);
dcl-s action char(1);

dow not *in03;
  exfmt SUPPMENU;
  select;
    when action = 'C'; SUPPMGMT(suppno);
    when action = 'U'; SUPPMGMT(suppno);
    when action = 'X'; leave;
  endsl;
enddo;

*inlr = *on; return;
