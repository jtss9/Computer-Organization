module Shift_Left_Two_28(data_i, data_o);

//I/O ports                    
input [26-1:0] data_i;
output [28-1:0] data_o;

//shift left 2
assign data_o = {data_i[25:0], 2'b00};   
endmodule