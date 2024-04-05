`include "pkg.sv"
`include "ALU.v"
`include "intfr.sv"

module top;
	import uvm_pkg::*;
	import pkg::*;
	//Interface declaration
	intfr ifc();

	//Connects the Interface to the DUT
ALU dut(ifc.A, 
        ifc.B,  
        ifc.a_en, 
        ifc.a_op,
        ifc.b_en,
        ifc.b_op, 
        ifc.rst_n,
        ifc.clk, 
        ifc.ALU_en,
        ifc.c
      	 );

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual intfr)::set
			(.scope("ifs"), .name("intfr"), .val(vif));

		//Executes the test
		run_test();
	end

	//Variable initialization
	initial begin
		vif.clk <= 1'b1;
	end

	//Clock generation
	always
		#5 vif.clk = ~vif.clk;
endmodule
