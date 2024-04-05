interface intfr(input logic clk);
  bit       rst_n;
  logic       ALU_en,a_en,b_en;
  logic [2:0] a_op;
  logic [1:0] b_op;
  logic signed [4:0] A;
  logic signed [4:0] B;
  logic signed [5:0] c;
  
    clocking driver_cb @(posedge clk);
    default input #1 output #1;
  output  A;
  output  B; 
  output  ALU_en;
  output  a_en;
  output  b_en;
  output  a_op; 
  output  b_op;
  
  endclocking
  
  clocking monitor_cb @(posedge clk);
    default input #0 output #1;
  input  A;
  input  B; 
  input  ALU_en;
  input  a_en;
  input  b_en;
  input  a_op;
  input  b_op;
 
  endclocking 
  
endinterface : intfr
