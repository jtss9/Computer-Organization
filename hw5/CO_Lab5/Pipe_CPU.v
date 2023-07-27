module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] instr, PC_i, PC_o, ReadData1, ReadData2, WriteData;
wire [32-1:0] signextend, ALUinput2, ALUResult;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOP;
wire [2-1:0] FURslt;
wire RegDst, MemtoReg;
wire RegWrite, ALUSrc, zero, overflow;
wire Jump, Branch, BranchType, MemWrite, MemRead;
wire [32-1:0] PC_add1, PC_add2, DM_ReadData;


wire [32-1:0] w1, mem2mux1;
wire [5-1:0] w2, WriteReg_addr;
wire    [32-1:0]    instr_id, PC_add1_id;

wire    [32-1:0]    ReadData1_ex, ReadData2_ex, signextend_ex, PC_add1_ex;
wire    [3-1:0]     ALUOP_ex;
wire    RegDst_ex, MemtoReg_ex;
wire    RegWrite_ex, ALUSrc_ex, Branch_ex, MemWrite_ex, MemRead_ex;
wire    [21-1:0]    instr_ex;

wire    [32-1:0]    ALUResult_mem, ReadData2_mem;
wire    RegWrite_mem, MemRead_mem, MemWrite_mem, Branch_mem;
wire    MemtoReg_mem;
wire    [5-1:0]     w2_mem;
wire    zero_mem;

wire    [32-1:0]    ALUResult_wb, DM_ReadData_wb;
wire    MemtoReg_wb, RegWrite_wb;
//modules
/*your code here*/

// IF stage
Mux2to1 #(.size(32)) Mux0(
        .data0_i(PC_add1),
        .data1_i(mem2mux1),
        .select_i(Branch_mem & zero_mem),
        .data_o(PC_i)
        );
Program_Counter PC(
        .clk_i(clk_i),
        .rst_n(rst_n),     
	    .pc_in_i(PC_i) , 
        .pc_out_o(PC_o) 
	    );
Instr_Memory IM(
        .pc_addr_i(PC_o),  
	    .instr_o(instr)    
	    ); 
Adder Adder1(
        .src1_i(PC_o),     
	    .src2_i(32'd4),
	    .sum_o(PC_add1)    
	    );
Pipe_Reg #(.size(32*2)) IF_ID(
        .clk_i(clk_i),
        .rst_i(rst_n),
        .data_i({instr, PC_add1}),
        .data_o({instr_id, PC_add1_id})
        );
        
// ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_id[25:21]) ,  
        .RTaddr_i(instr_id[20:16]) ,  
        .Wrtaddr_i(WriteReg_addr) ,  
        .Wrtdata_i(WriteData)  , 
        .RegWrite_i(RegWrite_wb),
        .RSdata_o(ReadData1) ,  
        .RTdata_o(ReadData2)   
        );             
Decoder Control(
        .instr_op_i(instr_id[31:26]),
        .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOP),
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),
	    .Jump_o(Jump),
	    .Branch_o(Branch),
	    .BranchType_o(BranchType),
	    .MemWrite_o(MemWrite),
	    .MemRead_o(MemRead),
	    .MemtoReg_o(MemtoReg)
	    );  
Sign_Extend SE(
        .data_i(instr_id[15:0]),
        .data_o(signextend)
        );
Pipe_Reg #(.size(32*4+3+1+1+5+21)) ID_EX(
        .clk_i(clk_i),
        .rst_i(rst_n),
        .data_i({ReadData1, ReadData2, signextend, PC_add1_id, ALUOP, RegDst, MemtoReg,
                    RegWrite, ALUSrc, Branch, MemWrite, MemRead, instr_id[20:0]}),
        .data_o({ReadData1_ex, ReadData2_ex, signextend_ex, PC_add1_ex, ALUOP_ex, RegDst_ex, MemtoReg_ex,
                    RegWrite_ex, ALUSrc_ex, Branch_ex, MemWrite_ex, MemRead_ex, instr_ex[20:0]})
        );

// EX stage
Shift_Left_Two_32 Shift32(
        .data_i(signextend_ex),
        .data_o(w1)
        );      
Adder Adder2(
        .src1_i(PC_add1_ex),     
	    .src2_i(w1),
	    .sum_o(PC_add2)    
	    ); 
Mux2to1 #(.size(32)) Mux1(
        .data0_i(ReadData2_ex),
        .data1_i(signextend_ex),
        .select_i(ALUSrc_ex),
        .data_o(ALUinput2)
        );  
ALU ALU(
        .aluSrc1(ReadData1_ex),
	    .aluSrc2(ALUinput2),
	    .ALU_operation_i(ALU_operation),
		.result(ALUResult),
		.zero(zero),
		.overflow(overflow)
	    );     
ALU_Ctrl AC(
        .funct_i(instr_ex[5:0]),   
        .ALUOp_i(ALUOP_ex),   
        .ALU_operation_o(ALU_operation),
		.FURslt_o(FURslt)
        );
Mux2to1 #(.size(5)) Mux2(
        .data0_i(instr_ex[20:16]),
        .data1_i(instr_ex[15:11]),
        .select_i(RegDst_ex),
        .data_o(w2)
        );
Pipe_Reg #(.size(32*3+1+5+1+4)) EX_MEM(
        .clk_i(clk_i),
        .rst_i(rst_n),
        .data_i({PC_add2, ALUResult, ReadData2_ex, zero, w2, 
                    MemtoReg_ex, RegWrite_ex, Branch_ex, MemRead_ex, MemWrite_ex}),
        .data_o({mem2mux1, ALUResult_mem, ReadData2_mem, zero_mem, w2_mem, 
                    MemtoReg_mem, RegWrite_mem, Branch_mem, MemRead_mem, MemWrite_mem})
        );

// MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALUResult_mem), 
        .data_i(ReadData2_mem),
        .MemRead_i(MemRead_mem), 
        .MemWrite_i(MemWrite_mem), 
        .data_o(DM_ReadData)
        );
Pipe_Reg #(.size(32*2+5+1+1)) MEM_WB(
        .clk_i(clk_i),
        .rst_i(rst_n),
        .data_i({ALUResult_mem, DM_ReadData, w2_mem, MemtoReg_mem, RegWrite_mem}),
        .data_o({ALUResult_wb, DM_ReadData_wb, WriteReg_addr, MemtoReg_wb, RegWrite_wb})
        );
// WB stage
Mux2to1 #(.size(32)) Mux3(
        .data0_i(ALUResult_wb),
        .data1_i(DM_ReadData_wb),
        .select_i(MemtoReg_wb),
        .data_o(WriteData)
        ); 

endmodule



