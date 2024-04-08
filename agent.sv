class agent extends uvm_agent;
	`uvm_component_utils(agent)

	uvm_analysis_port#(transaction) agent_ap_before;
	uvm_analysis_port#(transaction) agent_ap_after;

	sequencer		seqr;
	driver		drvr;
	monitor_before	mon_before;
	monitor_after	mon_after;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_ap_before	= new(.name("agent_ap_before"), .parent(this));
		agent_ap_after	= new(.name("agent_ap_after"), .parent(this));

		seqr		= sequencer::type_id::create(.name("seqr"), .parent(this));
		drvr		= driver::type_id::create(.name("drvr"), .parent(this));
		mon_before	= monitor_before::type_id::create(.name("mon_before"), .parent(this));
		mon_after	= monitor_after::type_id::create(.name("mon_after"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//TLM connections
		drvr.seq_item_port.connect(seqr.seq_item_export);
      
		mon_before.mon_ap_before.connect(agent_ap_before);
		mon_after.mon_ap_after.connect(agent_ap_after);
	endfunction: connect_phase
endclass: agent
