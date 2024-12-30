module divider(en, rst, clk, clk_N);
input clk, en, rst;
output reg clk_N;
parameter N = 100_000_000;
reg [31:0] counter=0;
always @(posedge clk or posedge rst)  begin
    if (rst) begin
        counter <= 0;
        clk_N <= 0;
    end
    else
    if (en) begin
        if (counter == N/2 - 1) begin
            counter <= 0;
            clk_N <= ~clk_N;
        end
        else
            counter <= counter + 1;
    end
end
endmodule
