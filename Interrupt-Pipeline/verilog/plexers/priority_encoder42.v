module priority_encoder42 (x0, x1, x2, x3, y, sel);
    input x0, x1, x2, x3;
    output [1:0] y;
    output sel;
    wire [1:0] y;
    
    assign y = x3 ? 2'b11 : x2 ? 2'b10 : x1 ? 2'b01 : x0 ? 2'b00 : 2'b00;
    assign sel = x3 | x2 | x1 | x0;
endmodule