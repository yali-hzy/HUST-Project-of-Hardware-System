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


module GetScreenRam(x, y, addr, data, color);
    parameter SCREEN_WIDTH = 11;
    parameter ADDR_WIDTH = 25;
    parameter DATA_WIDTH = 32;
    input [SCREEN_WIDTH-1:0] x;
    input [SCREEN_WIDTH-1:0] y;
    output [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] data;
    output [11:0] color;
    
    reg [3:0] colorId;
    reg [SCREEN_WIDTH-1:0] tmp_x;
    reg [SCREEN_WIDTH-1:0] tmp_y;
    
    localparam START_ADDR = 'h0;
    
    localparam width = 488;
    localparam height = 280;
    localparam wst = 76;
    localparam hst = 100; 
    
    always @* begin
        if (x > wst - 1 && x < wst + width)tmp_x = x;
        else tmp_x = wst + width;
        if (y > hst - 1 && y < hst + height)tmp_y = y;
        else tmp_y = hst + height;
    end
    
    assign addr = START_ADDR + ((((tmp_y-hst)*width) + tmp_x-wst) >> 3);
    always @(*) begin
        case (x[2:0])
            4: colorId = data[3:0];
            5: colorId = data[7:4];
            6: colorId = data[11:8];
            7: colorId = data[15:12];
            0: colorId = data[19:16];
            1: colorId = data[23:20];
            2: colorId = data[27:24];
            3: colorId = data[31:28];
        endcase
    end
    
    ColorCvt colorcvt(colorId, color);
    
    
endmodule