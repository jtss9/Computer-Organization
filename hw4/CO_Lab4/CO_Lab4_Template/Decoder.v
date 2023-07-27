module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	     	RegDst_o, MemtoReg_o;
output			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;
 
//Internal Signals
reg	[3-1:0] ALUOp_o;
reg			ALUSrc_o;
reg			RegWrite_o;
reg	    	RegDst_o, MemtoReg_o;
reg			Jump_o, Branch_o, BranchType_o, MemWrite_o, MemRead_o;

//Main function
/*your code here*/
always @(*)
begin
    case(instr_op_i)
        6'b000000:  begin   // R-type
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b010_0_1_1;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_0_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_0_0;
        end
        6'b001000:  begin   // addi
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b011_1_1_0;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_0_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_0_0;
        end
        6'b100001:  begin   // lw
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b000_1_1_0;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b1_0_1;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_0_0;
        end
        6'b100011:  begin   // sw
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b000_1_0_0;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_1_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_0_0;
        end
        6'b111011:  begin   // beq
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b001_0_0_0;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_0_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_1_0;
        end
        6'b100101:  begin   // bne
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b110_0_0_0;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_0_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b0_1_1;
        end
        6'b100010:  begin   // jump
            {ALUOp_o,ALUSrc_o,RegWrite_o,RegDst_o} <= 'b000_0_0_1;
            {MemtoReg_o, MemWrite_o, MemRead_o} <= 'b0_0_0;
            {Jump_o, Branch_o, BranchType_o} <= 'b1_0_0;
        end
    endcase
end
endmodule
   