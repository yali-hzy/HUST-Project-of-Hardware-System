module display(clk, LedData, SEG, AN);
    input clk;
    parameter WIDTH = 32;
    input [WIDTH-1:0] LedData;
    output [7:0] SEG;
    output [7:0] AN;
    wire [2:0] cnt;
    
    
    counter #(.WIDTH(3))CNT(clk, cnt);
    decoder3_8 de3_8(.num(cnt), .sel(AN));
    
    wire [3:0] digits [7:0];
    assign digits[0] = LedData[3:0];
    assign digits[1] = LedData[7:4];
    assign digits[2] = LedData[11:8];
    assign digits[3] = LedData[15:12];
    assign digits[4] = LedData[19:16];
    assign digits[5] = LedData[23:20];
    assign digits[6] = LedData[27:24];
    assign digits[7] = LedData[31:28];

    pattern P1(.code(digits[cnt]), .patt(SEG));

endmodule