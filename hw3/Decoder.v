module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
reg	[3-1:0] ALUOp_o;
reg			ALUSrc_o;
reg			RegWrite_o;
reg			RegDst_o;

//Main function
/*your code here*/
always @(*)
begin
    case(instr_op_i)
        6'b000000:  {RegWrite_o, ALUOp_o, ALUSrc_o, RegDst_o} <= {1'b1, 3'b001, 1'b0, 1'b1};    // R-type
        6'b001000:  {RegWrite_o, ALUOp_o, ALUSrc_o, RegDst_o} <= {1'b1, 3'b000, 1'b1, 1'b0};    // addi
        default:    {RegWrite_o, ALUOp_o, ALUSrc_o, RegDst_o} <= 0;
   endcase
end
endmodule
   