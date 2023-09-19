import uvm_pkg::*;

module top_hdl();
  reg clk = 0;
  initial // clock generator
  forever #1 clk = ~clk;
   
  // Interface
  fpu_intf intf(clk);
 
  // DUT connection	
  fpu dut (
    .clk    (clk), 
    .rmode  (intf.rmode),
    .fpu_op (intf.fpu_op),
    .opa    (intf.opa),
    .opb    (intf.opb),
    .out    (intf.out),
    .snan   (intf.snan),
    .qnan   (intf.qnan),
    .inf    (intf.inf),
    .ine    (intf.ine),
    .overflow    (intf.overflow),
    .underflow   (intf.underflow),
    .div_by_zero (intf.div_by_zero),
    .zero (intf.zero) 
  );
  

initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;
  
// Interface
  uvm_config_db #(virtual fpu_intf)::set (null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);
  	
end
  
endmodule