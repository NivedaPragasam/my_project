**free
ctl-opt dftactgrp(*no) option(*srcstmt);


dcl-s custno   char(10);
dcl-s resp     varchar(1024);


exec sql
  declare c1 cursor for
    select CUSTNO
      from MYLIB.CUSTMAS
     where STATUS = 'A';


exec sql open c1;


dou sqlcode <> 0;

  exec sql fetch c1 into :custno;


  if sqlcode <> 0;
     leave;
  endif;


  resp = GET('https://api.example.com/customers/' + %trim(custno));


  exec sql
    update MYLIB.CUSTMAS
       set STATUS = 'S'
     where CUSTNO = :custno;

enddo;


exec sql close c1;

*inlr = *on;
return;
