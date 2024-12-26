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
        0: tmp_color = 'hfff;
        1: tmp_color = 'hfcc;
        2: tmp_color = 'hcfc;
        3: tmp_color = 'hccf;
        4: tmp_color = 'hffc;
        5: tmp_color = 'h6cf;
        6: tmp_color = 'hcff;
        7: tmp_color = 'hfff;
        8: tmp_color = 'hccc;
        9: tmp_color = 'hc88;
        10: tmp_color = 'h8c8;
        11: tmp_color = 'h88c;
        default: tmp_color = 'h111;
    endcase
    assign color = tmp_color;
endmodule
