**FREE

ctl-opt dftactgrp(*NO) actgrp(*NEW);

 

dcl-f ITEMS usage(*update) keyed;


dcl-f DocFile organization(*streamfile)
              path('/home/user/doc1.txt')
              lrecl(1024)
              open(*read);
 
dcl-s textLine varchar(1024);
 
read DocFile textLine;
dow not %eof(DocFile);
   dsply textLine;
   read DocFile textLine;
enddo;