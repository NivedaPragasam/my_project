**free
ctl-opt dftactgrp(*no);

dcl-proc TODAY;
  dcl-pi TODAY ret char(8); end-pi;
  return %char(%date());
end-proc;

*inlr=*on; return;
