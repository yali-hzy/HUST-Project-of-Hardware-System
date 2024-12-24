`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/22 15:50:34
// Design Name: 
// Module Name: ColorCvt
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


module ColorCvt(colorId, color);
    input [3:0] colorId;
    output [11:0] color;
    reg [11:0] tmp_color;
    always @* case (colorId)
        0: tmp_color = 'h444;
        1: tmp_color = 'hccc;
        2: tmp_color = 'h0f0;
        3: tmp_color = 'h0c0;
        4: tmp_color = 'hff0;
        5: tmp_color = 'hdd0;
        6: tmp_color = 'hf00;
        7: tmp_color = 'hd00;
        default: tmp_color = 'h111;
    endcase
    assign color = tmp_color;
endmodule
