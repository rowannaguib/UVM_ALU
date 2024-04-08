/////////////////////////////////////////////////////////
class test extends uvm_test;
      `uvm_component_utils(test)
      env alu_env;

      function new(string name, uvm_component parent);
           super.new(name, parent);
      endfunction: new

      function void build_phase(uvm_phase phase);
           super.build_phase(phase);
           alu_env = env::type_id::create(.name("alu_env"), .parent(this));
        uvm_config_db#(uvm_object_wrapper)::set(this,"alu_env.ag.seqr.run_phase","default_sequence",alu_sequence::type_id::get());
      endfunction: build_phase
  
      task run_phase(uvm_phase phase);
           alu_sequence  seq;
           phase.raise_objection(.obj(this));
           seq = alu_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
        
        //            seq = alu_sequence::type_id::create("seq");
//            assert(seq.randomize());
//         seq.start(alu_env.agent.seqr);
           phase.drop_objection(.obj(this));
      endtask: run_phase
endclass: test
/////////////////////////////////////////////////////////