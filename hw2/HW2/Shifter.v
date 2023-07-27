module Shifter( result, leftRight, shamt, sftSrc  );
    
  output reg [31:0] result;

  input wire leftRight;
  input wire[4:0] shamt;
  input wire[31:0] sftSrc ;
  
  /*your code here*/ 
  always@(*)
  begin
    case (leftRight)
        'b0:    result <= {1'b0, sftSrc[31:1]};
        'b1:    result <= {sftSrc[30:0], 1'b0};
    endcase
  end
endmodule