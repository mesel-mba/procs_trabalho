create or replace PROCEDURE PRC_ATUALIZA_ITEM_PEDIDO_LOC AS 

V_TOT_ITEM NUMBER(10,2);
V_CONTADOR NUMBER(6) := 00;
V_TOT_ITEM2 NUMBER(10,2);
V_DT_RETIRADA DATE;
V_DT_ENTREGA DATE;
V_QT_DIAS NUMBER;
V_VL_LOCACAO NUMBER;

BEGIN
  FOR X IN (SELECT I.NR_PEDIDO, I.NR_ITEM, I.QT_DIAS, I.VL_LOCACAO, I.DT_RETIRADA FROM LOC_ITEM_LOCACAO I, LOC_PEDIDO_LOCACAO PED)
  LOOP
     
      V_TOT_ITEM := NVL(X.QT_DIAS,0) * NVL(X.VL_LOCACAO,0);
      V_DT_RETIRADA := X.DT_RETIRADA + 1;
      V_DT_ENTREGA := V_DT_RETIRADA;
      V_QT_DIAS := NVL(X.QT_DIAS,0) + 1;
      V_VL_LOCACAO := NVL(X.VL_LOCACAO,0) + 1;
      
      
      
      UPDATE LOC_ITEM_LOCACAO SET VL_TOTAL = V_TOT_ITEM, DT_RETIRADA = V_DT_RETIRADA, DT_ENTREGA = V_DT_ENTREGA, QT_DIAS = V_QT_DIAS, VL_LOCACAO = V_VL_LOCACAO
      WHERE  NR_PEDIDO = X.NR_PEDIDO AND NR_ITEM = X.NR_ITEM;

      V_CONTADOR := V_CONTADOR + 1;
      
      IF V_CONTADOR > 5000 THEN
         COMMIT;
         V_CONTADOR := 00;
      END IF;
      
  END LOOP;
  
END PRC_ATUALIZA_ITEM_PEDIDO_LOC;