**FREE

ctl-opt dftactgrp(*NO) actgrp(*NEW);
dcl-f ITEMS usage(*update) keyed;

dcl-f IMPCSV  disk usage(*input)

        organization(*streamfile)

        path('/tmp/itemsload.csv')

        lrecl(300) open(*read);

dcl-s line varchar(300);
importCSV();

*inlr = *on;

 

dcl-proc importCSV;

  dcl-s p1 int(10);

  dcl-s p2 int(10);

  read IMPCSV line;

  dow not %eof(IMPCSV);
    chain ITEMID ITEMS;

    if %found;

      update ITEMS;

    else;

      write ITEMS;

    endif;

 

    read IMPCSV line;

  enddo;

End-proc;