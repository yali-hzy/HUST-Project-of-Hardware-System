module epc(clk, rst, we, dataIn, EPC);
    input clk, we, rst;
    parameter WIDTH = 32;

    input [WIDTH-1:0] dataIn;

    output reg [WIDTH-1:0] EPC;

    initial begin
        EPC = 32'h00000000;
    end

    always @(posedge clk) begin
        if (rst) EPC <= 32'h00000000;
        else if (we) EPC <= dataIn;
    end

endmodule