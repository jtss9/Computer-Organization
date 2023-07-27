module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
reg		[4-1:0] ALU_operation_o;
reg		[2-1:0] FURslt_o;

//Main function
/*your code here*/
always@(*)
begin
    case(ALUOp_i)
        3'b000: {ALU_operation_o, FURslt_o} <= {4'b0010, 2'b00};    // addi
        3'b001: begin
                     case(funct_i)
                           6'b010010:   {ALU_operation_o, FURslt_o} <= {4'b0010, 2'b00};    // add
                           6'b010000:   {ALU_operation_o, FURslt_o} <= {4'b0110, 2'b00};    // sub
                           6'b010100:   {ALU_operation_o, FURslt_o} <= {4'b0001, 2'b00};    // and
                           6'b010110:   {ALU_operation_o, FURslt_o} <= {4'b0000, 2'b00};    // or
                           6'b010101:   {ALU_operation_o, FURslt_o} <= {4'b1101, 2'b00};    // nor
                           6'b100000:   {ALU_operation_o, FURslt_o} <= {4'b0111, 2'b00};    // slt
                           6'b000000:   {ALU_operation_o, FURslt_o} <= {4'b1000, 2'b01};    // sll
                           6'b000010:   {ALU_operation_o, FURslt_o} <= {4'b0000, 2'b01};    // srl
                           default:  {ALU_operation_o, FURslt_o} <= 0;
                     endcase
                end
     endcase
end

endmodule     
