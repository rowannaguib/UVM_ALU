`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

 	uvm_analysis_export #(transaction) sb_import_before;
	uvm_analysis_export #(transaction) sb_import_after;

	uvm_tlm_analysis_fifo #(transaction) before_fifo;
	uvm_tlm_analysis_fifo #(transaction) after_fifo;

	transaction tx_before; //in
	transaction tx_after; //out
    transaction tx_ref; //for reference model
	
  	transaction txQ_in[$];
  	transaction txQ_out[$];
  	transaction txQ_ref[$];
	
  	int count;
  
	function new(string name, uvm_component parent);
      super.new(name, parent); 
	endfunction: new
  
  //////////////////BUILD PHASE////////////////////
	function void build_phase(uvm_phase phase);
      super.build_phase(phase); 
      
//       txQ_in=new("txQ_in",this); 
//       txQ_out=new("txQ_out",this); 
//       txQ_ref=new("txQ_ref",this); 
      
      tx_before = transaction::type_id::create(.name("tx_before")); 
      tx_after = transaction::type_id::create(.name("tx_after")); 
      
      sb_import_before		= new("sb_import_before", this);   
      sb_import_after		= new("sb_import_after", this); 
 
      before_fifo		= new("before_fifo", this);  
      after_fifo		= new("after_fifo", this); 
	endfunction: build_phase

  //////////////////CONNECT PHASE////////////////////
	function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
		sb_import_before.connect(before_fifo.analysis_export);
		sb_import_after.connect(after_fifo.analysis_export);
	endfunction: connect_phase
  
  ////////////////// RUN PHASE////////////////////////////
   
  virtual task run_phase(uvm_phase phase);
		forever begin
          before_fifo.get(tx_before); 
          $cast(tx_ref,tx_before.clone());
          after_fifo.get(tx_after); 
			
          txQ_out.push_back(tx_after); 
          //predict
          predict();
          
			compare();
		end
	endtask: run_phase

  function void predict();
    if(!tx_ref.rst_n) begin
      	tx_ref.c = 'b0;
      if(txQ_ref.size() >= 1)
        if(txQ_ref[$].rst_n == 1) begin
          txQ_ref.pop_back();
          txQ_ref.push_back(tx_ref);
        end
    end
    else if (tx_ref.ALU_en) begin
          	if(tx_ref.a_en && !tx_ref.b_en) begin //a_op
            	case(tx_ref.a_op)
              	3'b0:  tx_ref.c = tx_ref.A + tx_ref.B;
              	3'b001: tx_ref.c = tx_ref.A - tx_ref.B;
              	3'b010: tx_ref.c = tx_ref.A ^ tx_ref.B;
              	3'b101: tx_ref.c = tx_ref.A || tx_ref.B;
              	3'b011: tx_ref.c = tx_ref.A & tx_ref.B;
              	3'b100: tx_ref.c = tx_ref.A & tx_ref.B;
              	3'b110: tx_ref.c = ~(tx_ref.A ^ tx_ref.B);
              	default: tx_ref.c = 6'b0;
            	endcase
          	end
        	else if (!tx_ref.a_en && tx_ref.b_en) begin //b_op set 1 
          	case(tx_ref.b_op)
              	2'b0:  tx_ref.c = ~(tx_ref.A & tx_ref.B);
              	2'b01:  tx_ref.c = tx_ref.A + tx_ref.B;
              	2'b10:  tx_ref.c = tx_ref.A + tx_ref.B;
              	default: tx_ref.c = 6'b0;
            	endcase
        	end
        	else if (tx_ref.a_en && tx_ref.b_en) begin //b_op set 2
          	case(tx_ref.b_op)
              	2'b0:  tx_ref.c = tx_ref.A ^ tx_ref.B;
              	2'b01:  tx_ref.c = ~(tx_ref.A ^ tx_ref.B);
              	2'b10:  tx_ref.c = tx_ref.A - 1;
              	2'b10:  tx_ref.c = tx_ref.B + 2;
              	default: tx_ref.c = 6'b0;
            	endcase
        	end
    end
    
    else 
      tx_ref.c = tx_after.c;
    
    txQ_ref.push_back(tx_ref);
  endfunction : predict
  
	virtual function void compare();
      if(txQ_ref.size() > 1) begin
      if(txQ_ref[$-1].c == txQ_out[$].c) begin
        `uvm_info("scoreboard", {"Test: OK!"}, UVM_LOW);
		end else begin
          `uvm_info("scoreboard", {"Test: Fail!"}, UVM_LOW);
		end
      end 
	endfunction: compare
endclass: scoreboard
