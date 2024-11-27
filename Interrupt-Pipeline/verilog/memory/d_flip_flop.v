module d_flip_flop(clk, clr, d, q);
    input clk, clr, d;
    output q;
    reg q;

    initial
        q = 1'b0;

    always @(posedge clk or posedge clr) begin
        if (clr)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule