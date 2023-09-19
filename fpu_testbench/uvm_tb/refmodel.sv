typedef struct{
  logic [31:0] out;
  logic snan;
  logic qnan;
  logic inf;
  logic ine;
  logic overflow;
  logic underflow;
  logic div_by_zero;
  logic zero;
} TipoDatoSalidas;



class refmodel;
  
  //STRUCT
  TipoDatoSalidas resultado;
  
  //SUM
  function logic [31:0] suma(logic [31:0] opa,logic [31:0] opb);
    begin
      logic [31:0] out;
      out = $shortrealtobits($bitstoshortreal(opa) + $bitstoshortreal(opb));
      return out;
    end
  endfunction
  
  
  //SUB
  function logic [31:0] resta(logic [31:0] opa,logic [31:0] opb);
    begin
      logic [31:0] out;
      out = $shortrealtobits($bitstoshortreal(opa) - $bitstoshortreal(opb));
      return out;
    end
  endfunction 
  
  //MULT
  function logic [31:0] multiplicacion(logic [31:0] opa,logic [31:0] opb);
    begin
      logic [31:0] out;
      out = $shortrealtobits($bitstoshortreal(opa) * $bitstoshortreal(opb));
      return out;
    end
  endfunction  
  
  //DIV
  function logic [31:0] division(logic [31:0] opa,logic [31:0] opb);
    begin
      logic [31:0] out;
      out = $shortrealtobits($bitstoshortreal(opa) / $bitstoshortreal(opb));
      
      return out;
    end
  endfunction
  
  
  //------------------------------------------
  //ROUND-NEAREST
  function logic [31:0] round_to_nereast_even(logic [31:0] op);
    begin
      logic [31:0] out = 0;
      out = int'(op);
      return out;
    end
  endfunction
  
  //ROUND-ZERO
  function logic [31:0] round_to_zero(logic [31:0] op);
    begin
      logic [31:0] out = 0;
      out = $shortrealtobits($floor($bitstoshortreal(op)));
      return out;
    end
  endfunction
  
  
  //ROUND-UP
  function logic [31:0] round_up(logic [31:0] op);
    begin
      logic [31:0] out = 0;
      if(op[31]==1'b1) out = $shortrealtobits($floor($bitstoshortreal(op)));
      else out = $shortrealtobits($ceil($bitstoshortreal(op)));
      return out;
    end
  endfunction  
  //funcion de round_down
  function logic [31:0] round_down(logic [31:0] op);
    begin
      logic [31:0] out = 0;
      if(op[31]==1'b1) out = $shortrealtobits($ceil($bitstoshortreal(op)));
      else out = $shortrealtobits($floor($bitstoshortreal(op)));
      return out;
    end
  endfunction
  
  //SNAN
  function logic fnsnan(logic sign_bit, logic [7:0] exponente, logic [22:0] mantissa,logic qnan);
    begin
      logic  snan = 0;
      if (exponente==8'b11111111 && mantissa[21]==1'b1 &&  mantissa[20:0]!=0 && qnan == 0)
        begin
          snan = 1;
        end
      return snan;
    end
  endfunction
  
  
  //QNAN
  function logic fnqnan(logic sign_bit, logic [7:0] exponente, logic [22:0] mantissa);
    begin
      logic  qnan = 0;
      if (exponente==8'b11111111 && mantissa[21]==1'b0 &&  mantissa[20:0]!=0)
        begin
          qnan = 1;
        end
      return qnan;
    end
  endfunction
  
  //INF
  function logic fninf(logic sign_bit, logic [7:0] exponente, logic [22:0] mantissa, logic [31:0] opb);
    begin
      logic  inf = 0;
      
      if ((exponente==8'b11111111 && mantissa[22:0]==0) || (opb == 0))
        begin
          inf = 1;
          
        end
      return inf;
    end
  endfunction  
  
  //INE
  function void fine (logic [31:0] opa,logic [31:0] opb);
    resultado.ine = 0;
    if((opa[30:23]<8'b10000000||opa[30:23]>=8'b10001011)||(opb[30:23]<8'b10000000||opb[30:23]>=8'b10001011)) begin
    	resultado.ine = 1;
    end
  endfunction
  
  //---------------------------OPERAR-----------------------------------------------------------
  function TipoDatoSalidas operar(logic [31:0] opa,logic [31:0] opb, logic [2:0] fpu_op,logic [1:0] rmode);
    begin
      
      
      //DATOS REFMODEL
      logic sign_bit = 0;
      logic [7:0] exponente = 8'b0;
      logic [22:0] mantissa = 23'b0;
      //se definen los registros con los que se va a operar
      logic [31:0] out = 0;
      logic snan = 0;
      logic qnan = 0;
      logic inf = 0;
      logic ine = 0;
      logic overflow = 0;
      logic underflow = 0;
      logic div_by_zero = 0;
      logic zero = 0;   
      
      
      
      //DATOS STRUCT
      resultado.out = out;
      resultado.snan = snan;
      resultado.qnan = qnan;
      resultado.inf = inf;
      resultado.ine = ine;
      resultado.overflow = overflow;
      resultado.underflow = underflow;
      resultado.div_by_zero = div_by_zero;
      resultado.zero = zero;         
      
      
      //OP MODES
      if (fpu_op == 3'b000)
        begin
          resultado.out = suma(opa,opb);
        end
      else if (fpu_op == 3'b001)
        begin
          resultado.out = resta(opa,opb);
        end
      else if (fpu_op == 3'b010)
        begin
          resultado.out = multiplicacion(opa,opb);
        end
      else if (fpu_op == 3'b011)
        begin
          resultado.out = division(opa,opb);
        end    
      
      //ROUND MODES
      if (rmode == 2'b00)
        begin
          resultado.out = round_to_nereast_even(resultado.out);
        end
      else if (rmode == 2'b01)
        begin
          resultado.out = round_to_zero(resultado.out);
        end
      else if (rmode == 2'b10)
        begin
          resultado.out = round_up(resultado.out);
        end
      else if (rmode == 2'b11)
        begin
          resultado.out = round_down(resultado.out);
        end   
      
      
      //se llama a funciones que calculan flags
      //-----------EXCEPTIONS-----------------------------------------
      //	b31 b30-b23         b22-b0
      //				 b23
      // NAN: 0 1111 1111 x xx xxxx xxxxxxxx xxxxxxxx (non-zero value)
      //sNAN: 0 1111 1111 x xx xxxx xxxxxxxx xxxxxxxx (non-zero) (result is NAN)
      //qNaN: 0 1111 1111 x xx xxxx xxxxxxxx xxxxxxxx (non-zero) (NaN-Inputs)
      //inf:  0 1111 1111 0 00 0000 00000000 00000000 (all-zero)
      //-------------------------------------------------------------------
      
      
      sign_bit = resultado.out[31];
      exponente = resultado.out[30:23];
      mantissa = resultado.out[22:0];      
      //sNAN
      resultado.snan = fnsnan(sign_bit,exponente,mantissa,resultado.qnan);
      //qNAN
      fine(opa,opb);
      //INF
      resultado.inf = fninf(sign_bit,exponente,mantissa,opb);

      return resultado;
    end
  endfunction
endclass