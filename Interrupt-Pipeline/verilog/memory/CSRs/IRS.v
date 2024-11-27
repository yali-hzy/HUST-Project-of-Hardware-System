module irs(clk, rst, we, dataIn, IRS);
    input clk, we, rst;
    input [2:0] dataIn;

    output reg [2:0] IRS;

    initial begin
        IRS = 3'b000;
    end

    always @(posedge clk) begin
        if (rst) IRS <= 3'b000;
        else if (we) begin
            IRS <= dataIn;
        end
    end

endmodule