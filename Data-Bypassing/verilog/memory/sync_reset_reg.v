module sync_reset_reg(clk, en, rst, d, q);
  parameter WIDTH = 32;
  input clk, en, rst;
  input [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;

  initial q = 0;

  always @(posedge clk) begin
    if (rst) q <= 0;
    else if (en) q <= d;
  end
endmodule