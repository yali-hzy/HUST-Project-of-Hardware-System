module counter(clk, out);
parameter WIDTH = 32;
input clk;                    // 计数时钟
output reg [WIDTH-1:0] out = 0;             // 计数值

always @(posedge clk)  begin  // 在时钟上升沿计数器加1
    out <= out + 1;                        // 功能实现
end                           
endmodule
