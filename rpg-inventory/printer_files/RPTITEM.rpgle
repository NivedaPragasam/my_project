FITEMS     IF   E           K DISK
REPRT  O    F     132    PRINTER OFLIND(*IN99)

D HDS1          S             50A

 /FREE
   *INLR = *OFF;

   HDS1 = 'ITEM MASTER LIST';
   EXCPT HDR1;

   READ ITEMS;

   DOU %EOF(ITEMS);

      FLD1 = %CHAR(ITEMID);
      FLD2 = ITEMNAME;
      FLD3 = UOM;
      FLD4 = %CHAR(PRICE);

      EXCPT DTL1;

      READ ITEMS;
   ENDDO;

   *INLR = *ON;
   RETURN;
 /END-FREE

