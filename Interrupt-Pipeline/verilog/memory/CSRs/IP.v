module ip(clk, rst, we, IRS, IP);
    input clk, we, rst;
    input [2:0] IRS;

    output reg [2:0] IP;

    initial begin
        IP = 3'b000;
    end

    always @(posedge clk) begin
        if (rst) IP <= 3'b000;
        else if (we) begin
            IP <= IP ^ IRS;
        end
    end

endmodule