module mux_21(a, b, sel, out);
    parameter WIDTH = 32;
    
    input [WIDTH-1:0] a, b;
    input sel;
    output [WIDTH-1:0] out;
    
    assign out = sel == 0 ? a : b;
    
endmodule
