//clase donde se definen las señales de entrada
class fpu_item extends uvm_sequence_item;
  //variables que permiten la generacion aleatorioa de numeros reales y modos de operacion
  
  rand logic [1:0]  rmode;
  rand logic [2:0]  fpu_op;
  
  rand logic signA;
  rand logic [7:0] expA;
  rand logic [22:0] mantA;
  
  rand logic signB;
  rand logic [7:0] expB;
  rand logic [22:0] mantB;
  
  logic [31:0] opa;
  logic [31:0] opb;
  
  string listaOperaciones[6] = '{ "Suma", "Resta", "Multiplicacion", "Division", "IntToFloat", "FloatToInt" };
  string listaRedondeos[4] = '{ "round_nearest_even", "round_to_zero", "round_up", "round_down"};
  
  //se hace el registro de objetos
  `uvm_object_utils_begin(fpu_item)
    `uvm_field_int(opa, UVM_ALL_ON)	
  	`uvm_field_int(opb, UVM_ALL_ON)
    `uvm_field_int(fpu_op, UVM_ALL_ON)
    `uvm_field_int(rmode, UVM_ALL_ON)
  `uvm_object_utils_end

  //constructor de la clase
  function new(string name = "fpu_item");
    super.new(name);
  endfunction

  
  //restricciones de generacion de los numeros aleatorios
  constraint operaciones{
    //0 = round_nearest_even //1 = round_to_zero
    //2 = round_up //3 = round_down    
    //opa <=01001010000111111111111111111111;
    //opa >=01000000000000000000000000000000;
    
    //opb <=01001010000001111111111111111111;
    //opb >=01000000000000000000000000000000;
    
    //expA <= 140;
    //expA >= 135;
    //expB <= 133;
    //expB >= 130;
    
    //mantA >= 23'b00000000000000000000000;
    //mantA <= 23'b01111111111111111111111;
    //mantB >= 23'b00000000000000000000000;
    //mantB <= 23'b01111111111111111111111;
    
    //mantA >= 1000;
    //mantA <= 100000;
    //mantB >= 1000;
    //mantB <= 100000;
    
    rmode  >= 2'b00;
    rmode  <= 2'b11;
    //0 = add //1 = sub //2 = mul //3 = div 
    //4 = Int to float conversion //5 = Float to int conversion    
    fpu_op >= 3'b000;
    fpu_op <= 3'b011;
    
      }
  
endclass

//clase donde se definen las señales de salida
class fpuS_item extends uvm_sequence_item;
	logic [31:0] out;
	bit snan;
	bit qnan;
	bit inf;
	bit ine;
	bit overflow;
	bit underflow;
	bit div_by_zero;
	bit zero;
  //se hace el registro de objetos
  `uvm_object_utils_begin(fpuS_item)
    `uvm_field_int(out, UVM_ALL_ON)
    `uvm_field_int(snan, UVM_ALL_ON)
    `uvm_field_int(qnan, UVM_ALL_ON)
    `uvm_field_int(inf, UVM_ALL_ON)
    `uvm_field_int(ine, UVM_ALL_ON)
    `uvm_field_int(overflow, UVM_ALL_ON)
    `uvm_field_int(underflow, UVM_ALL_ON)
    `uvm_field_int(div_by_zero, UVM_ALL_ON)
    `uvm_field_int(zero, UVM_ALL_ON)
    `uvm_object_utils_end

  //constructor de la clase
  function new(string name = "fpuS_item");
    super.new(name);
  endfunction
  
endclass


//clase donde se generan los items aleatoriamente
class gen_item_seq extends uvm_sequence;
  
  `uvm_object_utils(gen_item_seq)
  //constructor de la clase
  
  function new(string name = "gen_item_seq");
    super.new(name);
  endfunction
  
  //Random Seed
  rand int num;
  int maxIter=150;
  int minIter=100;
  
  //se restringe el numero de veces entre ciertos valores
  constraint c1 { num inside {[minIter:maxIter]}; }
  
  
  virtual task body();
    fpu_item f_item = fpu_item::type_id::create("f_item");
    for (int i = 0; i < num; i++) 
      begin
        start_item(f_item);
        
        
        if (!f_item.randomize() with {
          f_item.fpu_op inside {[000:011]};
          f_item.rmode inside {[00:11]};
          
          
        })begin
            `uvm_fatal("==SEQUENCE==", "Randomization failed for f_item");
          end
        f_item.opa={f_item.signA,f_item.expA,f_item.mantA};
        f_item.opb={f_item.signB,f_item.expB,f_item.mantB};
        
        `uvm_warning("==SEQUENCE==", $sformatf("==ITEM GENERATED=="))
        
        
        //f_item.print();
        finish_item(f_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass




//clase donde se envian las secuencias al dut
class fpu_driver extends uvm_driver #(fpu_item);
  `uvm_component_utils (fpu_driver)
  //constructor de la clase
  function new (string name = "fpu_driver", uvm_component parent = null);
    super.new (name, parent);
  endfunction  
  virtual fpu_intf intf;  
  //se constrye la phase y se comprueba la conexion con la db
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  //se ejecuta la phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
      begin 
        fpu_item f_item;
        //`uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
        seq_item_port.get_next_item(f_item);
        fork
          //Tareas en orden
          drive_fpu(f_item);
        join
        seq_item_port.item_done();
      end
  endtask  
  
  //envia los items al dut
  virtual task drive_fpu(fpu_item f_item);
    intf.rmode = f_item.rmode;
    intf.fpu_op = f_item.fpu_op;
    intf.opa = f_item.opa;	// se pasa en s al dut
    intf.opb = f_item.opb;	// se pasa en bits al dut
    repeat (5) begin
      @(posedge intf.clk);
    end
    
  endtask

endclass