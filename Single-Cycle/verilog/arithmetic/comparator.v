module comparator(a, b, is_equal, is_great, is_less);
    parameter WIDTH = 32;
    
    input [WIDTH-1:0] a, b;
    output is_equal, is_great, is_less;
    
    assign is_equal = (a == b) ? 1'b1 : 1'b0;
    assign is_great = (a > b) ? 1'b1 : 1'b0;
    assign is_less = (a < b) ? 1'b1 : 1'b0;

endmodule
