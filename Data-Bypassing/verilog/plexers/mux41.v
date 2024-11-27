module mux41(a, b, c, d, sel, out);
    parameter DATA_WIDTH = 32;
    input [DATA_WIDTH-1:0] a, b, c, d;
    input [1:0] sel;
    output reg [DATA_WIDTH-1:0] out;
    always @(*) begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule