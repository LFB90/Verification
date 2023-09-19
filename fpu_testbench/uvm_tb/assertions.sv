`define DUV_PATH top_hdl.dut

// Función para verificar si un entero es NaN
function logic is_nan(logic [31:0] value);
  	logic result=1'b0;
  if (value[30:23]==8'b11111111 && value[22:0]!=23'b00000000000000000000000) result=1'b1; // Es NaN
  //$display("QNAN Assertion Test: %b",result);
  	return result;
endfunction

function logic is_inf(logic [31:0] value);
 	logic result=1'b0;
  	if (value[30:23]==8'b11111111 && value[22:0]==23'b00000000000000000000000) result=1'b1; // Es Inf
  	return result;
endfunction


module whitebox();

  	//inputs and outputs
   concurrent_qnan: assert property ( @(posedge `DUV_PATH.clk) (  (is_nan(`DUV_PATH.opb) || is_nan(`DUV_PATH.opa) ) ) |-> ##4  !`DUV_PATH.qnan );
   concurrent_inf: assert property ( @(posedge `DUV_PATH.clk) (  ##4 is_inf(`DUV_PATH.opb) || is_inf(`DUV_PATH.opa) ) |-> `DUV_PATH.inf );
   inmediate_fpu_op: assert property ( @(posedge `DUV_PATH.clk) ((`DUV_PATH.fpu_op <= 3'b000) && (`DUV_PATH.fpu_op >= 3'b011)) |-> (`DUV_PATH.out == 32'b00000000000000000000000000000000) );
   inmediate_rmode: assert property ( @(posedge `DUV_PATH.clk) ((`DUV_PATH.fpu_op <= 2'b00) && (`DUV_PATH.fpu_op >= 2'b11)) |-> (`DUV_PATH.out == 32'b00000000000000000000000000000000) );
   concurrent_div_by_zero: assert property ( @(posedge `DUV_PATH.clk) (##5 `DUV_PATH.opb ) |-> !`DUV_PATH.div_by_zero );
   concurrent_zero: assert property ( @(posedge `DUV_PATH.clk) (##5 `DUV_PATH.opa ) |-> !`DUV_PATH.zero );
     
   	//outputs
    inmediate_snan_assertion: assert property ( @(posedge `DUV_PATH.clk) ( ##4 is_nan(`DUV_PATH.out) |-> !`DUV_PATH.snan ) );
    
    inmediate_ine: assert property ( @(posedge `DUV_PATH.clk) ( ##5 `DUV_PATH.ine |-> !(`DUV_PATH.out[30:23]>=149 && `DUV_PATH.out[30:23]<=127 ) ) );
     
    always_comb begin
    if ((`DUV_PATH.opa != 32'b0) && (`DUV_PATH.opb != 32'b0))
      assert((`DUV_PATH.out != `DUV_PATH.opa))
        else $error("La aserción no se cumple: la salida no conmuta el out = opa");
    end
    // El resultado es opb al operar con ceros
    always_comb begin
      if ((`DUV_PATH.opa != 32'b0) && (`DUV_PATH.opb != 32'b0))
        assert((`DUV_PATH.out != `DUV_PATH.opb))
          else $error("La aserción no se cumple: la salida no conmuta el out = opb");
    end

endmodule
