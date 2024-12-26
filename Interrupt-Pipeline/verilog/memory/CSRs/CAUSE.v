module cause(clk, rst, we, dataIn, CAUSE);
    input clk, we, rst;
    parameter WIDTH = 32;

    input [WIDTH-1:0] dataIn;

    output reg [WIDTH-1:0] CAUSE;

    initial begin
        CAUSE = 32'h00000000;
    end

    always @(posedge clk) begin
        if (rst) CAUSE <= 32'h00000000;
        else if (we) CAUSE <= dataIn;
    end

endmodule