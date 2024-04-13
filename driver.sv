class driver extends uvm_driver#(transaction);
	`uvm_component_utils(driver)

	virtual intfr vif;
 	transaction tx;
  
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

  //////////////   BUILD PHASE   //////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

      if(!uvm_config_db#(virtual intfr)::get(this,"*", "intfr",vif))
        `uvm_fatal(get_full_name(), {"Failed to get VIF from config DB!, vif must be set for: ",".vif"});
;
	endfunction: build_phase

  //////////////   RESET PHASE   ////////////////////////////// 
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this,"Reset phase has started");
    reset();
    phase.drop_objection(this,"Reset phase has ended");
  endtask : reset_phase
    
  virtual task reset();
		
		vif.A 		<= 0;
		vif.B 		<= 0;
		vif.a_en	<= 0;
      	vif.b_en 	<= 0;
      	vif.rst_n	<= 0;
      	vif.a_op 	<= 0;
      	vif.b_op 	<= 0;
      	vif.ALU_en 	<= 0;
    #(50); 
  	  	vif.rst_n	<= 1;
      	
  endtask: reset
  
  //////////////   RUN PHASE   //////////////////////////////
	task run_phase(uvm_phase phase);
   		drive();
	endtask: run_phase
  
//////////////   DRIVE() TASK   //////////////////////////////
	
 	task drive();
		
	vif.A 		<= 0;
		vif.B 		<= 0;
		vif.a_en	<= 0;
      	vif.b_en 	<= 0;
      	vif.rst_n	<= 1;
      	vif.a_op 	<= 0;
      	vif.b_op 	<= 0;
      	vif.ALU_en 	<= 0;
       
		
		forever begin
           @(posedge vif.clk);
			seq_item_port.get_next_item(tx);
   			vif.driver_cb.A 	<= tx.A;	
			vif.driver_cb.B 	<= tx.B;	
			vif.driver_cb.a_en	<= tx.a_en;
			vif.driver_cb.b_en 	<= tx.b_en;
			vif.rst_n			<= tx.rst_n;
			vif.driver_cb.a_op 	<= tx.a_op;
			vif.driver_cb.b_op 	<= tx.b_op;
			vif.driver_cb.ALU_en<= tx.ALU_en;
          seq_item_port.item_done();
					
		end
	endtask: drive
                                     
endclass: driver
