//clase monitor
class fpu_monitor_wr extends uvm_monitor;
  
  `uvm_component_utils (fpu_monitor_wr)
  virtual fpu_intf intf;
  
  uvm_analysis_port #(fpu_item)   drv_analysis_port; // cambiar a drv
  
  //constructor de la clase
  function new (string name, uvm_component parent= null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);  
    // Create an instance of the analysis port
    drv_analysis_port = new ("drv_analysis_port", this); // cambiar a drv
    
    // Get virtual interface handle from the configuration DB
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction
  
  // TAREA ESCRITURA
  virtual task run_phase (uvm_phase phase);
    fpu_item  data_obj = fpu_item::type_id::create ("data_obj", this);
    forever 
      begin
        @ (intf.opa | intf.opb | intf.fpu_op | intf.rmode);  
        data_obj.opa = intf.opa;
        data_obj.opb = intf.opb;
        data_obj.rmode = intf.rmode;
        data_obj.fpu_op = intf.fpu_op;
        drv_analysis_port.write (data_obj);
      end
  endtask
endclass

class fpu_monitor_rd extends uvm_monitor;
  `uvm_component_utils (fpu_monitor_rd)
  virtual fpu_intf intf;
  
  uvm_analysis_port #(fpuS_item)   mon_analysis_port;
  function new (string name, uvm_component parent= null);
    super.new (name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    // Create an instance of the analysis port
    mon_analysis_port = new ("mon_analysis_port", this);
    // Get virtual interface handle from the configuration DB
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction
  
  // TAREA LECTURA
  virtual task run_phase (uvm_phase phase);
    fpuS_item  data_obj = fpuS_item::type_id::create ("data_obj", this);
    forever begin
      @(intf.out|intf.snan|intf.qnan|intf.inf|intf.ine|intf.overflow|intf.div_by_zero|intf.zero); 
      data_obj.out = intf.out;
      data_obj.snan = intf.snan;
      data_obj.qnan = intf.qnan;
      data_obj.inf = intf.inf;
      data_obj.ine = intf.ine;
      data_obj.overflow = intf.overflow;
      data_obj.underflow = intf.underflow;
      data_obj.div_by_zero = intf.div_by_zero;
      data_obj.zero = intf.zero;
      mon_analysis_port.write (data_obj);
    end
    
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.out),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.snan),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.qnan),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.inf),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.ine),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.overflow),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.underflow),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.div_by_zero),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("Contents: %f",data_obj.zero),UVM_LOW);
  endtask	
endclass
