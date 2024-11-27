module highbit(x, y);
    input [2:0] x;
    output reg [2:0] y;

    // returns the highest bit set in x
    // eg. 4b1010 -> 4b1000

    always @(x) begin
        if (x[2]) begin
            y = 3'b100;
        end else if (x[1]) begin
            y = 3'b010;
        end else if (x[0]) begin
            y = 3'b001;
        end else begin
            y = 3'b000;
        end
    end
endmodule