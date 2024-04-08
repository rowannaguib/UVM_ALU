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
		c_cov: coverpoint out.c {bins C[5] = {-32, [-31:-1],0, [1:30],31};}
    endgroup : cov_out
  
	covergroup cov_in();
		A_cov:coverpoint in.A {bins A[5] = {-16, [-15:-1],0, [1:14],15};}
		B_cov:coverpoint in.B {bins B[5] = {-16, [-15:-1],0, [1:14],15};}
		a_en_cov: 	coverpoint in.a_en;
      	a_op_cov:  	coverpoint in.a_op;
		b_en_cov: 	coverpoint in.b_en;
      	b_op_cov:	coverpoint in.b_op;
		ALU_en_cov: coverpoint in.ALU_en;
		AxB: 		cross A_cov, B_cov;
	endgroup : cov_in
  
  	 function void write_cov_before (transaction tx);
		$cast(in,tx);
		cov_in.sample();
      `uvm_info({"write_before",get_full_name()}, {"Input transaction sampled"}, UVM_HIGH); 
 	 endfunction : write_cov_before
  	
 	 function void write_cov_after (transaction tx);
		$cast (out, tx);
		cov_out.sample();
     `uvm_info({"write after " ,get_full_name()}, {"Output transaction sampled"}, UVM_HIGH);
	endfunction: write_cov_after
  
endclass: cov