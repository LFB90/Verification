class funct_coverage extends uvm_component;

  `uvm_component_utils(funct_coverage)
  
  function new (string name = "funct_coverage", uvm_component parent = null);
    super.new (name, parent);
    cov_in = new(); 
    cov_out = new();
    cov_operaciones = new();
  endfunction
  
  virtual fpu_intf intf;

  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge intf.clk) begin
        cov_in.sample();  
        cov_out.sample();
        cov_operaciones.sample();
      end
    end
  endtask  

   
  //COVERAGE INPUT
  covergroup cov_in;
    
    c_opa: coverpoint intf.opa {option.auto_bin_max=32;}
    c_opb: coverpoint intf.opb {option.auto_bin_max=32;}
    c_rmode: coverpoint intf.rmode[1:0];
    c_fpu_op: coverpoint intf.fpu_op[1:0];
    
    c_rmode_bin: coverpoint intf.rmode {bins seq = {[0:3]};}
    c_fpu_op_bin: coverpoint intf.fpu_op {bins seq = {[0:3]};}
    
    cross_repeat: cross c_rmode_bin, c_fpu_op_bin;
    
    //c_fpu_op_seq: coverpoint intf.fpu_op {bins seq = (0=>1=>2=>3=>0);}
    //bins rmode_5times = (1[*5]);
    
  endgroup

  //COVERAGE OUTPUT
  covergroup cov_out;
    
    c_snan: coverpoint intf.snan;
    c_qnan: coverpoint intf.qnan;
    c_inf: coverpoint intf.inf;
    c_ine: coverpoint intf.ine;
    c_overflow: coverpoint intf.overflow;
    c_underflow: coverpoint intf.underflow;
    c_div_by_zero: coverpoint intf.div_by_zero;
    c_zero: coverpoint intf.zero;
    
    c_out: coverpoint intf.out {option.auto_bin_max=32;}
    
    // Cobertura de las aserciones
  	// Cobertura para inf assert 
    
  	p_inf_assert: coverpoint { intf.inf, intf.opb, intf.opa } iff (!intf.inf && (is_inf(intf.opb) || is_inf(intf.opa) || intf.opb == 0));
    // Cobertura para qnan assert  
  	p_qnan_assert: coverpoint { intf.qnan, intf.opb, intf.opa } iff (!intf.qnan && (is_nan(intf.opb) || is_nan(intf.opa)));
  	// Cobertura para la aserción de div_by_zero
  	p_div_by_zero_assert: coverpoint { intf.opb, intf.fpu_op, intf.div_by_zero } iff (intf.opb == 0 && intf.fpu_op == 3'b011 && intf.div_by_zero == 1'b1);
    // Cobertura para la aserción de zero
    p_zero_assert: coverpoint { intf.out, intf.zero} iff (intf.out == 0 && intf.zero == 1'b1);
    
    
  endgroup
  
  covergroup cov_operaciones;
    p_fpu_op0_rmode: coverpoint { intf.fpu_op, intf.rmode } iff (intf.fpu_op == 3'b000 && (intf.rmode == 2'b00 || intf.rmode == 2'b01 || intf.rmode == 2'b10 || intf.rmode == 2'b11));
    
    p_fpu_op1_rmode: coverpoint { intf.fpu_op, intf.rmode } iff (intf.fpu_op == 3'b001 && (intf.rmode == 2'b00 || intf.rmode == 2'b01 || intf.rmode == 2'b10 || intf.rmode == 2'b11));
    
    p_fpu_op2_rmode: coverpoint { intf.fpu_op, intf.rmode } iff (intf.fpu_op == 3'b010 && (intf.rmode == 2'b00 || intf.rmode == 2'b01 || intf.rmode == 2'b10 || intf.rmode == 2'b11));
    
    p_fpu_op3_rmode: coverpoint { intf.fpu_op, intf.rmode } iff (intf.fpu_op == 3'b011 && (intf.rmode == 2'b00 || intf.rmode == 2'b01 || intf.rmode == 2'b10 || intf.rmode == 2'b11));     
  endgroup
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    //COVERAGE INPUT
    $display("COV_IN Overall: %3.2f%% coverage achieved.",
    cov_in.get_coverage());
    $display("COV_IN c_opa: %3.2f%% coverage achieved.",
    cov_in.c_opa.get_coverage());
    $display("COV_IN c_opb: %3.2f%% coverage achieved.",
    cov_in.c_opb.get_coverage());
    $display("COV_IN c_fpu_op: %3.2f%% coverage achieved.",
    cov_in.c_fpu_op.get_coverage());
    
    
    
    //COVERAGE OUTPUT
    $display("COV_OUT Overall: %3.2f%% coverage achieved.",    
    cov_out.get_coverage());
    $display("COV_OUT c_out: %3.2f%% coverage achieved.",
    cov_out.c_out.get_coverage());
    $display("COV_OUT c_snan: %3.2f%% coverage achieved.",
    cov_out.c_snan.get_coverage());
    $display("COV_OUT c_qnan: %3.2f%% coverage achieved.",
    cov_out.c_qnan.get_coverage());
    $display("COV_OUT c_inf: %3.2f%% coverage achieved.",
    cov_out.c_inf.get_coverage());
    $display("COV_OUT c_ine: %3.2f%% coverage achieved.",
    cov_out.c_ine.get_coverage());
    $display("COV_OUT c_overflow: %3.2f%% coverage achieved.",
    cov_out.c_overflow.get_coverage());
    $display("COV_OUT c_underflow: %3.2f%% coverage achieved.",
    cov_out.c_underflow.get_coverage());
    $display("COV_OUT c_div_by_zero: %3.2f%% coverage achieved.",
    cov_out.c_div_by_zero.get_coverage());
    $display("COV_OUT c_zero: %3.2f%% coverage achieved.",
    cov_out.c_zero.get_coverage());
    
    // OPERACIONES: COVERAGE SUMA
    $display("COV_SUMA p_fpu_op_rmode: %3.2f%% de cobertura alcanzada.",
    cov_operaciones.p_fpu_op0_rmode.get_coverage());
    //COVERAGE RESTA
    $display("COV_RESTA p_fpu_op_rmode: %3.2f%% de cobertura alcanzada.",
    cov_operaciones.p_fpu_op1_rmode.get_coverage());
    //COVERAGE MULTIPLICACIÓN
    $display("COV_MULTIPLICACION p_fpu_op_rmode: %3.2f%% de cobertura alcanzada.",
    cov_operaciones.p_fpu_op2_rmode.get_coverage());
    //COVERAGE DIVISIÓN
    $display("COV_DIVISION p_fpu_op_rmode: %3.2f%% de cobertura alcanzada.",
             cov_operaciones.p_fpu_op3_rmode.get_coverage());
	
    //COVERAGE Assertions
	$display("COV_OUT p_inf_assert: %3.2f%% de cobertura alcanzada.",
             cov_out.p_inf_assert.get_coverage());
	$display("COV_OUT p_qnan_assert: %3.2f%% de cobertura alcanzada.",
             cov_out.p_qnan_assert.get_coverage());
    $display("COV_OUT p_div_by_zero_assert: %3.2f%% de cobertura alcanzada.",
             cov_out.p_div_by_zero_assert.get_coverage());
    $display("COV_OUT p_zero_assert_assert: %3.2f%% de cobertura alcanzada.",
             cov_out.p_zero_assert.get_coverage());
    
    
  endfunction
  
endclass