module counter(clk, out);
parameter WIDTH = 32;
input clk;                    // ����ʱ��
output reg [WIDTH-1:0] out = 0;             // ����ֵ

always @(posedge clk)  begin  // ��ʱ�������ؼ�������1
    out <= out + 1;                        // ����ʵ��
end                           
endmodule
