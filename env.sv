/////////////////////////////////////////////////////////
class env extends uvm_env;
      `uvm_component_utils(env)
  
       scoreboard sb;
		agent ag;
		  cov 	cv;
  
      function new(string name, uvm_component parent);
          super.new(name, parent);
      endfunction: new

      function void build_phase(uvm_phase phase);
          super.build_phase(phase);
        	
        	sb = scoreboard::type_id::create(.name("sb"), .parent(this));
        	ag = agent::type_id::create(.name("ag"), .parent(this));
        	cv = cov::type_id::create(.name("cv"), .parent(this));
      endfunction: build_phase
  
      function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
        
        ag.agent_ap_before.connect(sb.sb_import_before);
        ag.agent_ap_after.connect(sb.sb_import_after);
        
        ag.agent_ap_before.connect(cv.cov_import_before);
        ag.agent_ap_after.connect(cv.cov_import_after);
        
      endfunction: connect_phase
endclass: env
/////////////////////////////////////////////////////////
