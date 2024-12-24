module bit_extend(sign, in, out);
    parameter IN_WIDTH = 1;
    parameter OUT_WIDTH = 32;

    input sign;
    input [IN_WIDTH-1:0] in;
    output reg [OUT_WIDTH-1:0] out;

    always @(*) begin
        if (sign) 
            out = { {(OUT_WIDTH-IN_WIDTH){in[IN_WIDTH-1]}}, in }; // 符号扩展
        else 
            out = { {(OUT_WIDTH-IN_WIDTH){1'b0}}, in }; // 零扩展
    end

endmodule