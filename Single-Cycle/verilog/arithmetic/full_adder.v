module full_adder(a, b, c_in, sum, c_out);
    parameter WIDTH = 32;
    
    input [WIDTH-1:0] a, b;
    input c_in;
    output [WIDTH-1:0] sum;
    output c_out;
    
    assign { c_out, sum } = a + b + c_in;
endmodule
