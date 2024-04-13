// Code your design here
module ALU ( 
    input signed [4:0] A,
    input signed [4:0] B,
    input a_en ,
    input [2:0] a_op ,
    input b_en , 
    input [1:0] b_op , 
    input rst_n, 
    input clk, 
    input ALU_en,
    output reg signed [5:0] c
);

parameter [2:0] ADD_a   = 'b0,
                SUB_a   = 3'b001,
                XOR_a   = 3'b010,
                OR_a    = 3'b101,
                AND_a   = 3'b011,
                AND__a  = 3'b100,
                XNOR_a  = 3'b110,
                NULL_a  = 3'b111,
                //b_op set 1 
                NAND_b_1  = 2'b0,
                ADD_b_1   = 2'b01,
                ADD__b_1   = 2'b10,
                NULL_b_1  = 2'b11,
                //b_op set 2
                XOR_b_2   = 2'b0,
                XNOR_b_2  = 2'b01,
                DEC_b_2   = 2'b10, //A-1
                ADD2_b_2  = 2'b11; //B+2

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        c <= 6'b0;
    end
    else begin
        if(ALU_en)begin
            if(a_en && !b_en)begin //a_op
                case (a_op)
                    ADD_a:  c <= A + B;
                    SUB_a:  c <= A - B;
                    XOR_a:  c <= A ^ B;
                    OR_a:   c <= A || B;
                    AND_a:  c <= A & B;
                    AND__a: c <= A & B;
                    XNOR_a: c <= ~(A ^ B);
              //      NULL_a: assert (A != 5'b0) else $error("illegal input alu_in_b != 8'h00");
                    default: c <=6'b0; 
                endcase
            end
            else if(b_en && !a_en)begin //b_op set 1
                case (b_op)
                    NAND_b_1: c <= ~(A & B);
                    ADD_b_1 : c <= A + B;
                    ADD_b_1 : c <= A + B;
                 //   NULL_b_1: assert (A != 5'b0) else $error("illegal input alu_in_b != 8'h00");
                   default: c <=6'b0;
                endcase
            end
            else if(a_en && b_en)begin // b_op set 2
                case (b_op)
                    XOR_b_2 : c <= A ^ B; 
                    XNOR_b_2: c <= ~(A ^ B);
                    DEC_b_2 : c <= A - 1;
                    ADD2_b_2: c <= B + 2;
                   default: c <=6'b0;
                endcase
            end
          else 
            c <= c;
        end
        else 
            c <= c;
    end
end
endmodule
