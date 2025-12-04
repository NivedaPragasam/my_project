**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-pi *n;
  invno char(10);
end-pi;

dsply ('INVCHK: checking invoice ' + %trim(invno));

// example decision
if %trim(invno) = 'TEST';
  dsply('INVCHK: special test path');
endif;

*inlr = *on;
return;
