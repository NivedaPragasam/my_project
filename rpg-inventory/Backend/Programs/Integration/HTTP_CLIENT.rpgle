**free
ctl-opt dftactgrp(*no);

dcl-pr HTTP_GET varchar(1024) extproc('HTTP_GET'); // illustrative
  url pointer value;
end-pr;

dcl-proc GET;
  dcl-pi GET ret varchar(1024);
    url char(256) const;
  end-pi;
  // Placeholder - return a canned response
  ret = '{ "status": "OK", "id": "12345" }';
  return ret;
end-proc;

*inlr=*on;
return;
