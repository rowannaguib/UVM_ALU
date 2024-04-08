class monitor_after extends uvm_monitor;
	`uvm_component_utils(monitor_after)

	uvm_analysis_port#(transaction) mon_ap_after;

	virtual intfr vif;

	transaction tx;
    
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
 	function new(string name, uvm_component parent);
		super.new(name, parent);
		//cg = new;
	endfunction: new
/*	
	//For coverage
	transaction tx_cg;

	//Define coverpoints
	covergroup cg;
      		ina_cp:     coverpoint sa_tx_cg.ina;
      		inb_cp:     coverpoint sa_tx_cg.inb;
		cross ina_cp, inb_cp;
	endgroup: cg

*/
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	 
  		if(!(uvm_config_db #(virtual intfr)::get(this, "*", "vif", vif))) 
    //  `uvm_error("MONITOR_CLASS", "Failed to get VIF from config DB!");
          `uvm_fatal(get_full_name(),{"Failed to get VIF from config DB!, vif must be set for:" , ".intfr"});
          
   	mon_ap_after= new(.name("mon_ap_after"), .parent(this));
          
	endfunction: build_phase

	task run_phase(uvm_phase phase);
// 		tx = transaction::type_id::create(.name("tx"), .contxt(get_full_name()));
      tx = transaction::type_id::create(.name("tx"));
		forever begin
// 			@(posedge vif.sig_clock)
// 			begin
				//sample output
              @(posedge vif.clk);
        		tx.c = tx.c;
              
              // send item to scoreboard
              mon_ap_after.write(tx);
              `uvm_info({"monitor_after",get_full_name()},{"output tx sent to scoreboard"}, UVM_MEDIUM);
               
		end
	endtask: run_phase

/*	virtual function void predictor();
		sa_tx.out = sa_tx.ina + sa_tx.inb;
	endfunction: predictor
    */
endclass: monitor_after
