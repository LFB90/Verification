//conexion con el DUV
interface fpu_intf(input clk);
  logic [1:0]  rmode;
  logic [2:0]  fpu_op;
  logic [31:0] opa;
  logic [31:0] opb;
  logic [31:0] out;
  logic        snan;
  logic		   qnan;
  logic        inf;
  logic        ine;
  logic        overflow;
  logic        underflow;
  logic        div_by_zero;
  logic        zero;
endinterface : fpu_intf