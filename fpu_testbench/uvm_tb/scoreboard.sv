`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

`include "refmodel.sv"

class fpu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (fpu_scoreboard)
  refmodel modeloReferencia = new();
  
  
    function new (string name, uvm_component parent=null);
		super.new (name, parent);
      	
	endfunction
  
  uvm_analysis_imp_drv #(fpu_item, fpu_scoreboard) fpu_drv;
  uvm_analysis_imp_mon #(fpuS_item, fpu_scoreboard) fpu_mon;  
  
  
  function void build_phase (uvm_phase phase);
    fpu_drv = new ("fpu_drv", this);
    fpu_mon = new ("fpu_mon", this);
  endfunction
 
  
  //shortreal ref_model_REAL [$];				//almacena resultados en real
  logic [31:0] ref_model_BITS [$];		//almacena resultados en bits 
  
  
  TipoDatoSalidas ref_model_resultado [$];
 

 virtual function void write_drv(fpu_item item);
   //`uvm_info ("DRIVER->SB", $sformatf("Data received OPA: Bin->%b Float-> %f", item.opa,$bitstoshortreal(item.opa)), UVM_MEDIUM);
   //`uvm_info ("DRIVER->SB", $sformatf("Data received OPB: Bin->%b Float-> %f", item.opb,$bitstoshortreal(item.opb)), UVM_MEDIUM); 
   `uvm_info ("DRIVER->SB", $sformatf("Data received OPA: Bin->%b Float-> %f     BIAS-> %b | %d Mant: %d", item.opa,$bitstoshortreal(item.opa),item.opa[30:23],item.opa[30:23],item.opa[22:0]), UVM_MEDIUM);
   `uvm_info ("DRIVER->SB", $sformatf("Data received OPB: Bin->%b Float-> %f     BIAS-> %b | %d Mant: %d", item.opb,$bitstoshortreal(item.opb),item.opb[30:23],item.opb[30:23],item.opb[22:0]), UVM_MEDIUM);
   `uvm_info ("DRIVER->SB", $sformatf("Data received fpu_op= %s", item.listaOperaciones[item.fpu_op]), UVM_MEDIUM);
   `uvm_info ("DRIVER->SB", $sformatf("Data received rmode= %s", item.listaRedondeos[item.rmode]), UVM_MEDIUM);
  begin
    
    
    ref_model_resultado.push_back(modeloReferencia.operar(item.opa,item.opb,item.fpu_op,item.rmode));
    
    
  end
endfunction

  	//chequer
  virtual function void write_mon (fpuS_item item);
    
    
    TipoDatoSalidas result_ref = ref_model_resultado.pop_front();
    
    
    
    //monitoring section
    
    //`uvm_info("COMPARED Data", $sformatf("\nDUT= %b\nREF= %b",item.out,result_ref_BITS), UVM_MEDIUM);
    
    
    //CHECKER
    //if (item.out !== result_ref.out || item.snan !== result_ref.snan || item.qnan !== result_ref.qnan || item.inf !== result_ref.inf || item.ine !== result_ref.ine)
    if (item.out !== result_ref.out || item.snan !== result_ref.snan || item.qnan !== result_ref.qnan || item.inf !== result_ref.inf )
      begin
        `uvm_error("SB-MISSMATCH","DATA MISSMATCH");
        
        `uvm_info("SB-INFO", $sformatf("DUT= %f \t\t\t\t\t\t\t DUT= %b",$bitstoshortreal(item.out),item.out), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("REF= %f \t\t\t\t\t\t\t REF= %b",$bitstoshortreal(result_ref.out),result_ref.out), UVM_MEDIUM);
        
        //binary interchange format
        
        `uvm_info("SB-INFO", $sformatf("DUT-Sign: %b DUT-Exp: %b  -> %d DUT-Mant: %b - %d",item.out[31],item.out[30:23],item.out[30:23],item.out[22:0],item.out[22:0]),UVM_MEDIUM);
        //`uvm_info("SB-INFO", $sformatf("REF-Sign: %b REF-Exp: %b  -> %d REF-Mant: %b - %d",result_ref.out[31],result_ref.out[30:23],result_ref.out[30:23],result_ref.out[22:0],result_ref.out[22:0]), UVM_MEDIUM);
        
        `uvm_info("SB-INFO", $sformatf("DUT-sNAN:      %b | REF-sNAN: %b",item.snan,result_ref.snan), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-qNAN:      %b | REF-qNAN: %b",item.qnan,result_ref.qnan), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-INF:       %b | REF-INF:  %b",item.inf,result_ref.inf), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-INE:       %b | REF-INE:  %b",item.ine,result_ref.ine), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-OVERFLOW:  %b | REF-OVE:  %b",item.overflow,result_ref.overflow), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-UNDERFLOW: %b | REF-UND:  %b",item.underflow,result_ref.underflow), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-DIVZERO:   %b | REF-DIVZ: %b",item.div_by_zero,result_ref.div_by_zero), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-ZERO:      %b | REF-ZERO: %b",item.zero,result_ref.zero), UVM_MEDIUM);
        
      end
    else 
      begin
        `uvm_info("SB-PASS", $sformatf("DUT= %f , DUT= %b , Mant: %d",$bitstoshortreal(item.out),item.out,item.out[22:0]), UVM_MEDIUM);
        `uvm_info("SB-PASS", $sformatf("REF= %f , REF= %b , Mant: %d",$bitstoshortreal(result_ref.out),result_ref.out,result_ref.out[22:0]), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-sNAN:      %b | REF-sNAN: %b",item.snan,result_ref.snan), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-qNAN:      %b | REF-qNAN: %b",item.qnan,result_ref.qnan), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-INF:       %b | REF-INF:  %b",item.inf,result_ref.inf), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-INE:       %b | REF-INE:  %b",item.ine,result_ref.ine), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-OVERFLOW:  %b | REF-OVE:  %b",item.overflow,result_ref.overflow), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-UNDERFLOW: %b | REF-UND:  %b",item.underflow,result_ref.underflow), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-DIVZERO:   %b | REF-DIVZ: %b",item.div_by_zero,result_ref.div_by_zero), UVM_MEDIUM);
        `uvm_info("SB-INFO", $sformatf("DUT-ZERO:      %b | REF-ZERO: %b",item.zero,result_ref.zero), UVM_MEDIUM);
        //item.print();
    end
    
    //exception monitoring
    
    
  endfunction
  
  virtual task run_phase (uvm_phase phase);
  endtask
  
  virtual function void check_phase (uvm_phase phase);
    if(ref_model_BITS.size() > 0)
      `uvm_warning("SB Warn", $sformatf("FPU not empty at check phase. Fpu still has 0x%0h data items allocated", ref_model_BITS.size()));
  endfunction

endclass