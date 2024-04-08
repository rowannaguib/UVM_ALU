`include "pkg.sv"
//`include "ALU.v"
`include "intfr.sv"

module top();
	import uvm_pkg::*;
	import pkg::*;
  
  	logic clk;
	//Interface declaration
  intfr ifc(clk);

	//Connects the Interface to the DUT
ALU dut(ifc.A, 
        ifc.B,  
        ifc.a_en, 
        ifc.a_op,
        ifc.b_en,
        ifc.b_op, 
        ifc.rst_n,
        clk, 
        ifc.ALU_en,
        ifc.c
      	 );
  
   initial begin
     $dumpfile("top.vcd");
    $dumpvars;
  end
	//Variable initialization
	initial begin
      clk = 0;
		//Registers the Interface in the configuration block so that other
		//blocks can use it
      
      uvm_config_db#(virtual intfr)::set(null,"*","vif",ifc);
   
      run_test();
	end

	//Clock generation
	always
		#5 clk = ~clk;
endmodule
