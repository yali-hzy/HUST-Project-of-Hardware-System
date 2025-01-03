module divider(start, clk, clk_N);
  input clk, start;                          // 系统时钟
  output reg clk_N;                   // 分频后的时钟
  reg [31:0] counter;
  /* 计数器变量，通过计数实现分频。
   当计数器从0计数到(N/2-1)时，
   输出时钟翻转，计数器清零 */
   parameter N = 500_000_00;
  initial begin
    counter = 0;
    clk_N = 0;
  end
  always @(posedge clk)  begin    // 时钟上升沿
    if (start) begin
        if (counter == N - 1) begin
          clk_N   <=  ~clk_N;
          counter <= 0;
        end
        else
          counter <= counter + 1;
    end
  end
endmodule
