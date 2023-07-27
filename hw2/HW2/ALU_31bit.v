module ALU_31bit( result, carryOut, overflow, set, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output reg result;
  output wire carryOut;
  output wire overflow;
  output wire set;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  reg a_in, b_in;
  wire fa_result;
  Full_adder FA(
            .sum(fa_result),
            .carryOut(carryOut),
            .carryIn(carryIn),
            .input1(a_in),
            .input2(b_in)
        );
  wire w0, w1;
  or g0(w0, a_in, b_in);
  and g1(w1, a_in, b_in);

  assign overflow = ((operation == 2'b10) || (operation == 2'b11))? (carryIn != carryOut) : 'b0;
  assign set = fa_result;
  always@(*)
  begin
    a_in = (invertA)? ~a : a;
    b_in = (invertB)? ~b : b;
    case(operation)
    2'b00:  result <= w0;
    2'b01:  result <= w1;
    2'b10:  result <= fa_result;
    2'b11:  result <= less;
    endcase
  end
endmodule