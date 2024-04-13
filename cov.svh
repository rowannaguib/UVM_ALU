`uvm_analysis_imp_decl(_cov_before)
`uvm_analysis_imp_decl(_cov_after)
class cov extends uvm_component;
  `uvm_component_utils (cov)
  uvm_analysis_imp_cov_before#(transaction, cov) cov_import_before; 
  uvm_analysis_imp_cov_after#(transaction, cov)  cov_import_after;
 
		transaction 	in;
		transaction		out;
  
	function new(string name, uvm_component parent);
      super.new(name, parent);
		cov_out = new();
		cov_in = new();
	endfunction
  
  function void build_phase (uvm_phase phase);
      super.build_phase (phase);
	
      in = transaction::type_id::create(.name("in"), .parent(this));
		out = transaction::type_id::create(.name("out"), .parent(this));
		cov_import_before = new("cov_analysis_before", this);
		cov_import_after = new("cov_analysis_after", this);
	endfunction: build_phase

  	covergroup cov_out();
		cg: coverpoint out.c {bins off = {0};}
    endgroup : cov_out
  
	covergroup cov_in();
		 ina:coverpoint in.A;
   		 inb:coverpoint in.B;
   		   opa: coverpoint in.a_op;
 		en_a: coverpoint in.a_en;
     	 cross opa,en_a{
   		 bins bin_op_a = binsof (opa) intersect{[0:7]};
   		 }
   		 opb: coverpoint in.b_op;
   		 en_b: coverpoint in.b_en;
 		 cross opb,en_b{
   		 bins bin_op_b = binsof (opb) intersect{[0:3]};
 			}
	rst:coverpoint in.rst_n {bins activated = {0}; bins deactivated = {1};}
		ALU_en_cov: coverpoint in.ALU_en;
	endgroup : cov_in
  
  	 function void write_cov_before (transaction tx);
		$cast(in,tx);
		cov_in.sample();
      `uvm_info({"write_before",get_full_name()}, {"Input transaction sampled"}, UVM_LOW); 
 	 endfunction : write_cov_before
  	
 	 function void write_cov_after (transaction tx);
		$cast (out, tx);
		cov_out.sample();
     `uvm_info({"write after " ,get_full_name()}, {"Output transaction sampled"}, UVM_LOW);
	endfunction: write_cov_after
  
endclass: cov
