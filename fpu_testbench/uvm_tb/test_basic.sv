class test_basic extends uvm_test;
  
  `uvm_component_utils(test_basic)
 
  function new (string name="test_basic", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new
  
  virtual fpu_intf intf;
  fpu_env env;  
  
  virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
        `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end
      
    env  = fpu_env::type_id::create ("env", this);

    uvm_config_db #(virtual fpu_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);
      
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
    print();
    
  endfunction : end_of_elaboration_phase

  //sum_item_seq seq;
  gen_item_seq seq;

  virtual task run_phase(uvm_phase phase);

    phase.raise_objection (this);
   
    seq = gen_item_seq::type_id::create("seq");
    
    seq.randomize();
    
    seq.start(env.fpu_ag_active.fpu_seqr);
    
    phase.drop_objection (this);
  endtask

endclass