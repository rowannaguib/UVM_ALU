/*class base_sequence extends uvm_sequence;
  `uvm_object_utils(base_sequence)
  
  transaction reset_pkt;
 
  //Constructor
  function new(string name= "base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
  endfunction
   
 //Body Task
 task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
    
    reset_pkt = sequence_item::type_id::create("reset_pkt");
    start_item(reset_pkt);
    reset_pkt.randomize() with {reset==1;};
    finish_item(reset_pkt);
        
  endtask: body
 
  
endclass: base_sequence  */

class alu_sequence extends uvm_sequence#(transaction);
	`uvm_object_utils(alu_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new
      
   /*   task pre_body();
        if(stating_phase != null)
          starting_phase.raise_objection(this);
          
      endtask
      */
	task body();
		transaction tx;
		
      repeat(100) begin
/*		tx = transaction::type_id::create(.name("tx"),.contxt(get_full_name()));

		start_item(tx);
		assert(tx.randomize());
		//`uvm_info("alu_sequence", tx.sprint(), UVM_LOW);
          finish_item(tx);
          */
          `uvm_do(tx);
		end
	endtask: body
   /*   
      task post_body();
        if(stating_phase != null)
          starting_phase.drop_objection(this);
          
      endtask
      */
endclass: alu_sequence

typedef uvm_sequencer#(transaction) sequencer;
