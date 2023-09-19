class test_doubles extends test_basic;
  
  `uvm_component_utils(test_doubles)
 
  function new (string name="test_doubles", uvm_component parent=null);
    super.new (name,parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
      
    factory.set_type_override_by_name("gen_item_seq","double_item_seq");
    
    factory.print();
    
  endfunction
  
endclass

class double_item_seq extends gen_item_seq;
  
  `uvm_object_utils(double_item_seq)
 
  function new (string name="double_item_seq");
    super.new (name);
  
  endfunction : new
  
  //rand logic f_item.opa[18:0];
  //rand logic f_item.opb[18:0];
  //Random Seed
  //rand int num;
  //int maxIter=250;
  //int minIter=200;
  
  //se restringe el numero de veces entre ciertos valores
  //constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        //Doubles
        if (!f_item.randomize() with {
          f_item.expA inside {[127:137]};
          f_item.expB inside {[127:137]};
          f_item.mantA[9:0] == 10'b0000000000;
          f_item.mantB[9:0] == 10'b0000000000;
          
          
        })begin
            `uvm_fatal("==SEQUENCE==", "Randomization failed for f_item");
          end
        f_item.opa={f_item.signA,f_item.expA,f_item.mantA};
        f_item.opb={f_item.signB,f_item.expB,f_item.mantB};
        
        `uvm_warning("==SEQUENCE==", $sformatf("==ITEM GENERATED=="))
        
        finish_item(f_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
  
endclass