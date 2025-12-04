**free
ctl-opt dftactgrp(*no);

dcl-proc RTRIM;
  dcl-pi RTRIM ret char(200); val char(200) const; end-pi;
  return %trimr(val);
end-proc;
*inlr=*on; return;
