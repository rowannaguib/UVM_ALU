/////////////////////////////////////////////////////////
class env extends uvm_env;
      `uvm_component_utils(env)
       agent ag;
       scoreboard sb;
	   cov 	cv;
  
      function new(string name, uvm_component parent);
          super.new(name, parent);
      endfunction: new

      function void build_phase(uvm_phase phase);
          super.build_phase(phase);
        	ag = agent::type_id::create(.name("ag"), .parent(this));
        	sb = scoreboard::type_id::create(.name("sb"), .parent(this));
        	cv = cov::type_id::create(.name("cv"), .parent(this));
      endfunction: build_phase
  
      function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
        
//           ag.agent_ap_before.connect(sb.sb_export_before);
//           ag.agent_ap_after.connect(sb.sb_export_after);
        
        ag.agent_ap_before.connect(sb.sb_imp_before);
        ag.agent_ap_after.connect(sb.sb_imp_after);
        
        ag.agent_ap_before.connect(cv.cov_imp_before);
        ag.agent_ap_after.connect(cv.cov_imp_after);
        
      endfunction: connect_phase
endclass: env
/////////////////////////////////////////////////////////