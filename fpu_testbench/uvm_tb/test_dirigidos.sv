//div_zero
class test_div_zero extends test_basic;
  
  `uvm_component_utils(test_div_zero)
 
  function new (string name="test_div_zero", uvm_component parent=null);
    super.new (name,parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
      
    factory.set_type_override_by_name("gen_item_seq","div_zero_item_seq");
    
    factory.print();
    
  endfunction
  
endclass

//zero
class test_zero extends test_basic;
  
  `uvm_component_utils(test_zero)
 
  function new (string name="test_zero", uvm_component parent=null);
    super.new (name,parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
      
    factory.set_type_override_by_name("gen_item_seq","zero_item_seq");
    
    factory.print();
    
  endfunction
  
endclass

//NAN
class test_nan extends test_basic;
  
  `uvm_component_utils(test_nan)
 
  function new (string name="test_nan", uvm_component parent=null);
    super.new (name,parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
      
    factory.set_type_override_by_name("gen_item_seq","nan_item_seq");
    
    factory.print();
    
  endfunction
  
endclass

//INF
class test_inf extends test_basic;
  
  `uvm_component_utils(test_inf)
 
  function new (string name="test_inf", uvm_component parent=null);
    super.new (name,parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
      
    factory.set_type_override_by_name("gen_item_seq","inf_item_seq");
    
    factory.print();
    
  endfunction
  
endclass

//--------------------------------------------SEQ--------------------------------------------------

//div zero sequence
class div_zero_item_seq extends gen_item_seq;
  
  `uvm_object_utils(div_zero_item_seq)
 
  function new (string name="div_zero_item_seq");
    super.new (name);
  
  endfunction : new
  
  //rand logic f_item.opa[18:0];
  //rand logic f_item.opb[18:0];
  //Random Seed
  //rand int num;
  int maxIter=50;
  int minIter=10;
  
  //se restringe el numero de veces entre ciertos valores
  constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        //Doubles
        if (!f_item.randomize() with {
          f_item.expA inside {[127:137]};
          f_item.expB == 8'b00000000;
          
          f_item.mantA[9:0]  == 23'b0000000000;
          //f_item.mantB[22:0] == 23'b00000000000000000000000;
          
          
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


//zero sequence
class zero_item_seq extends gen_item_seq;
  
  `uvm_object_utils(zero_item_seq)
 
  function new (string name="zero_item_seq");
    super.new (name);
  
  endfunction : new
  
  //rand logic f_item.opa[18:0];
  //rand logic f_item.opb[18:0];
  //Random Seed
  //rand int num;
  int maxIter=50;
  int minIter=10;
  
  //se restringe el numero de veces entre ciertos valores
  constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        //Doubles
        if (!f_item.randomize() with {
          f_item.expB inside {[127:137]};
          f_item.expA == 8'b00000000;
          
          f_item.mantB[9:0]  == 23'b0000000000;
          f_item.mantA[22:0] == 23'b00000000000000000000000;
          
          
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

//nan sequence
class nan_item_seq extends gen_item_seq;
  
  `uvm_object_utils(nan_item_seq)
 
  function new (string name="nan_item_seq");
    super.new (name);
  
  endfunction : new
  
  //rand logic f_item.opa[18:0];
  //rand logic f_item.opb[18:0];
  //Random Seed
  //rand int num;
  int maxIter=50;
  int minIter=10;
  
  //se restringe el numero de veces entre ciertos valores
  constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        //Doubles
        if (!f_item.randomize() with {
          f_item.expA inside {[127:137]};
          f_item.expB == 8'b11111111;
          
          f_item.mantA[9:0]  == 23'b0000000000;
          //f_item.mantB[22:0] == 23'b00000000000000000000000;
          
          
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

//nan sequence
class inf_item_seq extends gen_item_seq;
  
  `uvm_object_utils(inf_item_seq)
 
  function new (string name="inf_item_seq");
    super.new (name);
  
  endfunction : new
  
  //rand logic f_item.opa[18:0];
  //rand logic f_item.opb[18:0];
  //Random Seed
  //rand int num;
  int maxIter=50;
  int minIter=10;
  
  //se restringe el numero de veces entre ciertos valores
  constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        //Doubles
        if (!f_item.randomize() with {
          f_item.expA inside {[127:137]};
          f_item.expB == 8'b11111111;
          
          f_item.mantA[9:0]  == 23'b0000000000;
          f_item.mantB[22:0] == 23'b00000000000000000000000;
          
          
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