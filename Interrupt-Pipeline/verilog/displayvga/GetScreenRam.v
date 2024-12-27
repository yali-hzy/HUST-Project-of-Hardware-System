`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:51:03
// Design Name: 
// Module Name: GetScreenRam
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


module GetScreenRam(rst, x, y, addr, data, color);
    parameter SCREEN_WIDTH = 11;
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;
    
    input rst;
    input [SCREEN_WIDTH-1:0] x;
    input [SCREEN_WIDTH-1:0] y;
    output [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] data;
    output [11:0] color;
    
    reg [3:0] colorId;
    
    localparam START_ADDR = 'h0;
    localparam Width = 640;
    localparam Height = 480;
    localparam width = 488;
    localparam height = 280;
//    localparam width = 640;
//    localparam height = 480;
    localparam wst = (Width - width)/2;
    localparam hst = (Height - height)/2; 
    
//    always @* begin
//        if (x >= wst && x < wst + width)tmp_x = x;
//        else tmp_x = wst + width;
//        if (y >= hst && y < hst + height)tmp_y = y;
//        else tmp_y = hst + height;
//    end
//    reg[ADDR_WIDTH-1:0] max_addr = 0;
//    wire [ADDR_WIDTH-1:0] tmp_addr;
//    assign tmp_addr = ((y*width) + x)/8;
    
//    always @* begin
//        if(rst == 1)max_addr = 0;
//        else  
//        if (tmp_addr > max_addr) max_addr = tmp_addr;
//        else max_addr = max_addr;
//    end
    
    assign addr = ((y*width) + x)/8;
    
    always @(*) begin
        case (x[2:0])
            0: colorId = data[3:0];
            1: colorId = data[7:4];
            2: colorId = data[11:8];
            3: colorId = data[15:12];
            4: colorId = data[19:16];
            5: colorId = data[23:20];
            6: colorId = data[27:24];
            7: colorId = data[31:28];
        endcase
    end
    
    ColorCvt colorcvt(colorId, color);
    
    
endmodule