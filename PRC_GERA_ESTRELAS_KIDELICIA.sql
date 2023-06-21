create or replace PROCEDURE PRC_GERA_ESTRELAS_KIDELICIA AS 
v_vl_med_compra number(30,2) := 00;
v_estrelas number(1) := 0;

v_contador number := 00;

cursor c_cli is select c.nr_cliente, p.nr_pedido from kd_cliente c, kd_item_pedido p;

rcli c_cli%rowtype;

BEGIN
  open  c_cli;
  loop
     fetch c_cli into rcli;

     if c_cli%notfound then
        exit;
     end if;


      select avg(vl_tot_pedido) 
      into   v_vl_med_compra
      from   kd_pedido
      where nr_cliente = rcli.nr_cliente;

     if v_vl_med_compra < 100 then
         v_estrelas := 1;
      elsif v_vl_med_compra < 151 then
           v_estrelas := 2;
      elsif v_vl_med_compra < 155 then
           v_estrelas := 3;    
      elsif v_vl_med_compra < 162 then
           v_estrelas := 4;       
      else
           v_estrelas := 5;
      end if;

      update kd_cliente set qt_estrelas = v_estrelas, vl_medio_compra = v_vl_med_compra
      where nr_cliente = rcli.nr_cliente;

      v_contador := v_contador + 1;
      if v_contador > 3000 then
        commit;
        v_contador := 00;
      end if;

  end loop;  
  close c_cli;
END PRC_GERA_ESTRELAS_KIDELICIA;