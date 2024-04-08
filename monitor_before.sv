class monitor_before extends uvm_monitor;
	`uvm_component_utils(monitor_before)

	uvm_analysis_port#(transaction) mon_ap_before;

	virtual intfr vif;
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
  
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

//       `uvm_info("MONITOR_CLASS", "Build Phase!",tx.sprint(), UVM_HIGH);
    
     `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH);
    
  //  monitor_port = new("monitor_port", this);
    
    if(!(uvm_config_db #(virtual intfr)::get(this, "*", "vif", vif))) 
      `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!");
      //     `uvm_fatal(get_full_name(),{"Failed to get VIF from config DB!, vif must be set for:" , ".intfr"});
      
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
      
	endfunction : build_phase

	task run_phase(uvm_phase phase);
	
		transaction tx;
		tx = transaction::type_id::create(.name("tx"), .contxt(get_full_name()));

		forever begin
//           @(posedge vif.clk)
// 			begin
				//sample inputs
              @(posedge vif.clk);
        		tx.A = vif.A;
        		tx.B = vif.B;
        		tx.a_en = vif.a_en;
				tx.a_op = vif.a_op;
        		tx.b_op = vif.b_op;
        		tx.b_en = vif.b_en;
              	tx.ALU_en = vif.ALU_en;
          	    tx.rst_n = vif.rst_n;
              
        		/*//sample output
        		@(posedge vif.clock);
        		item.result = vif.result;*/
              
              // send item to scoreboard
              mon_ap_before.write(tx);
              `uvm_info({"monitor_before",get_full_name()},{"input tx sent to scoreboard"}, UVM_MEDIUM);
    
		end
	endtask: run_phase
endclass: monitor_before
