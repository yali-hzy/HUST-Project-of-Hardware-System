`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:50:48
// Design Name: 
// Module Name: Screen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Screen(color, clk, info);
    parameter SCREEN_WIDTH = 10;
    
    wire [SCREEN_WIDTH-1:0] x;
    wire [SCREEN_WIDTH-1:0] y;
    input clk;
    input [31:0] info;
    output [11:0] color;
    
//    reg [7:0] done0[1:0][63:0][600:0];
//    reg [7:0] done1[1:0][63:0][600:0];
//    reg [7:0] done2[1:0][63:0][600:0];
//    reg [7:0] done3[1:0][63:0][600:0];
//    reg [7:0] done4[1:0][63:0][600:0];
//    reg [7:0] done5[1:0][63:0][600:0];
//    reg [7:0] done6[1:0][63:0][600:0];
//    reg [7:0] done7[1:0][63:0][600:0];
//    reg [7:0] done8[1:0][63:0][600:0];
//    reg [7:0] done9[1:0][63:0][600:0];
//    reg [7:0] done10[1:0][63:0][600:0];
//    reg [7:0] done11[1:0][63:0][600:0];
//    reg [7:0] done12[1:0][63:0][600:0];

//    reg [7:0] done0[1:0][63:0][300:0];
//    reg [7:0] done1[1:0][63:0][300:0];
//    reg [7:0] done2[1:0][63:0][300:0];
//    reg [7:0] done3[1:0][63:0][300:0];
//    reg [7:0] done4[1:0][63:0][300:0];
//    reg [7:0] done5[1:0][63:0][300:0];
//    reg [7:0] done6[1:0][63:0][300:0];
    
//    reg done[1:0][640:0][480:0];
    
    
    wire [3:0] colorId;
//    reg i = 0;
//    ColorCvt colorCvt(colorId, color);
    localparam Width = 640;
    localparam Height = 480;
    localparam width = 488;
    localparam height = 280;
    localparam wst = 76;
    localparam hst = 100; 
    
    assign x = (info[7+2*SCREEN_WIDTH:7+SCREEN_WIDTH+1]>>1);
    assign y = (info[7+SCREEN_WIDTH:8]>>1);
    reg [0:0] flag;
    always @* begin
        if (x > wst - 1 && x < wst + width && y > hst - 1 && y < hst + height) flag = 1;
        else flag = 0;
    end
    
    
    wire [17:0] idx;
    assign idx = ((y-hst)*(width) + x-wst);
    
//    vram mem(.clka(clk), .clkb(clk), .addra(idx), .addrb(idx), .dina(info[3:0]), .doutb(colorId), .wea(flag), .ena(flag), .enb(flag));
    
//    wire [SCREEN_WIDTH-7:0] type;
//    wire [5:0] bias;
//    assign bias = x[5:0];
//    assign type = x[SCREEN_WIDTH-1:6];
    
    
//    always @* begin
////        case (type)
////            0: colorId = done0[i][bias][y];
////            1: colorId = done1[i][bias][y];
////            2: colorId = done2[i][bias][y];
////            3: colorId = done3[i][bias][y];
////            4: colorId = done4[i][bias][y];
////            5: colorId = done5[i][bias][y];
////            6: colorId = done6[i][bias][y];
////            7: colorId = done7[i][bias][y];
////            8: colorId = done8[i][bias][y];
////            9: colorId = done9[i][bias][y];
////            10: colorId = done10[i][bias][y];
////            11: colorId = done11[i][bias][y];
////            12: colorId = done12[i][bias][y];
////        endcase
        
//        colorId = done[i][x][y];
//    end
    
//    always @(posedge clk) begin
//        if(info[31])begin
//            i <= i^1;
//        end
////        case (type)
////            0: done0[i^1][bias][y] <= info[7:0];
////            1: done1[i^1][bias][y] <= info[7:0];
////            2: done2[i^1][bias][y] <= info[7:0];
////            3: done3[i^1][bias][y] <= info[7:0];
////            4: done4[i^1][bias][y] <= info[7:0];
////            5: done5[i^1][bias][y] <= info[7:0];
////            6: done6[i^1][bias][y] <= info[7:0];
////            7: done7[i^1][bias][y] <= info[7:0];
////            8: done8[i^1][bias][y] <= info[7:0];
////            9: done9[i^1][bias][y] <= info[7:0];
////            10: done10[i^1][bias][y] <= info[7:0];
////            11: done11[i^1][bias][y] <= info[7:0];
////            12: done12[i^1][bias][y] <= info[7:0];
////        endcase
//        done[i^1][x][y] <= info[3:0];
//    end 
    
endmodule
