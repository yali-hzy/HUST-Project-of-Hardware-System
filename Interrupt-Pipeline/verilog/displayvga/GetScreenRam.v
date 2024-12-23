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


module GetScreenRam(clk, x, y, addr, data, Info);
    parameter SCREEN_WIDTH = 10;
    parameter ADDR_WIDTH = 25;
    parameter DATA_WIDTH = 32;
    input clk;
    input [SCREEN_WIDTH-1:0] x;
    input [SCREEN_WIDTH-1:0] y;
    output [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] data;
    output [DATA_WIDTH-1:0] Info;
    
    reg [DATA_WIDTH-1:0] tmp_Info;
    reg [SCREEN_WIDTH-1:0] tmp_x;
    reg [SCREEN_WIDTH-1:0] tmp_y;
    
    localparam START_ADDR = 'h0;
    localparam HPW = 96;
    localparam HFP = 8;
    localparam Width = 640;
    localparam HMax = 800;
    
    localparam VPW = 2;
    localparam Height = 480;
    localparam VFP = 2;
    localparam VMax = 525;
    localparam Boarder = 3;
    
    localparam width = 480;
    localparam height = 280;
    localparam wst = (Width - width) >> 1;
    localparam hst = (Height - height) >> 1; 
    
    always @* begin
        if (x < Width)tmp_x = x;
        else tmp_x = Width;
        if (y < Height)tmp_y = y;
        else tmp_y = Height;
    end
    
    assign addr = START_ADDR + ((((tmp_y-hst)*Width) + tmp_x-wst) >> 3);
    always @(posedge clk) begin
        if (x == HMax - 1 && y == VMax - 1) begin
            tmp_Info[31] <= 1;
        end else begin
            tmp_Info[31] <= 0;
        end
        tmp_Info[7+2*SCREEN_WIDTH:7+SCREEN_WIDTH+1] <= tmp_x;
        tmp_Info[7+SCREEN_WIDTH:8] <= tmp_y;
        case (x[2:0])
            4: tmp_Info[3:0] <= data[3:0];
            5: tmp_Info[3:0] <= data[7:4];
            6: tmp_Info[3:0] <= data[11:8];
            7: tmp_Info[3:0] <= data[15:12];
            0: tmp_Info[3:0] <= data[19:16];
            1: tmp_Info[3:0] <= data[23:20];
            2: tmp_Info[3:0] <= data[27:24];
            3: tmp_Info[3:0] <= data[31:28];
        endcase
    end
    assign Info = tmp_Info;
    
    
endmodule