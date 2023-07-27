module Mux2to1( data0_i, data1_i, select_i, data_o );

parameter size = 0;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	select_i;
output reg	[size-1:0] data_o; 

//Main function
/*your code here*/
always@(*) 
begin
    case(select_i)
        'b0:  data_o <= data0_i;
        'b1:  data_o <= data1_i;
    endcase
end 
endmodule      
    