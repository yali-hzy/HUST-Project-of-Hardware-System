`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:49:59
// Design Name: 
// Module Name: Vga
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


module Vga (rawClk, rst, R, G, B, HS, VS, x, y, color);
    parameter SCREEN_WIDTH = 10;
//    parameter MAX_WIDTH = 11;
    localparam HPW = 96;
    localparam HFP = 8;
    localparam Width = 640;
    localparam HMax = 800;
    
    localparam VPW = 2;
    localparam Height = 480;
    localparam VFP = 2;
    localparam VMax = 525;
    localparam Boarder = 3;
    
    input rawClk;
    input rst;
    input [11:0] color;
    
    output [3:0] R;
    output [3:0] G;
    output [3:0] B;
    output HS;
    output VS;
    
    
    output [SCREEN_WIDTH-1:0] x;
    output [SCREEN_WIDTH-1:0] y;
    
    
    reg [11:0] RGB;
    assign {R, G, B} = RGB;
    
    reg [SCREEN_WIDTH-1:0] tmp_x;
    reg [SCREEN_WIDTH-1:0] tmp_y;
    reg tmp_HS;
    reg tmp_VS;
//    reg [SCREEN_WIDTH-1:0] out_x;
//    reg [SCREEN_WIDTH-1:0] out_y;
    
    
    // Horizontal counter
    always @(posedge rawClk) begin
        if (rst) tmp_x <= 0;
        else begin
            if (tmp_x < HMax - 1) tmp_x <= tmp_x + 1;
            else tmp_x <= 0;
//            if (tmp_x < Width) out_x <= tmp_x;
//            else out_x = Width; 
        end
    end
    
    always @(posedge rawClk) begin
        if (rst) tmp_HS <= 1;
        else begin
		    if (tmp_x >= HFP + Width - 1 && tmp_x < HFP + Width + HPW - 1) tmp_HS <= 0;
		    else tmp_HS <= 1;
		end
    end
    
    // Vertical counter
    always @(posedge rawClk) begin
        if (rst) tmp_y <= 0;
        else begin
            if (tmp_x == HMax - 1) begin
                if (tmp_y < VMax - 1) tmp_y <= tmp_y + 1;
                else tmp_y <= 0;
            end
            else tmp_y <= tmp_y;
            
//            if (tmp_y < Height) out_y = tmp_y;
//            else out_y = Height;
        end
    end
    
    always @(posedge rawClk) begin
        if (rst) tmp_VS <= 1;
        else begin
            if (tmp_y >= VFP + Height - 1 && tmp_y < VFP + Height + VPW - 1) tmp_VS <= 0;
            else tmp_VS <= 1;
        end
    end
    
    always @(posedge rawClk) begin
        if (rst) RGB <= 0;
        else begin
            if (tmp_y < Height - Boarder && tmp_y >= Boarder
                && tmp_x < Width - Boarder && tmp_x >= Boarder)
                RGB <= color;
            else if (tmp_x < Width && tmp_y < Height) RGB <= 'h111;
            else RGB <= 0;
        end
    end
    
        
    
    assign x = tmp_x;
    assign y = tmp_y;
    assign HS = tmp_HS;
    assign VS = tmp_VS;
    
endmodule
