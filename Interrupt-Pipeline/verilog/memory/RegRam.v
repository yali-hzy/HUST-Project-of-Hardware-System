`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/24 20:22:40
// Design Name: 
// Module Name: RegRam
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


module RegRam(rst, we, sel, addr, d, q
, dispAddr, dispColor, clk
);
    parameter ADDR_WIDTH = 16;
    parameter DATA_WIDTH = 32;
    input we, rst, clk;
    input [3:0] sel;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] d;
    input [ADDR_WIDTH-1:0] dispAddr;
    output [DATA_WIDTH-1:0] q;
//    wire [DATA_WIDTH-1:0] q;
    output [DATA_WIDTH-1:0] dispColor;
    reg [DATA_WIDTH-1:0] ram [(2**ADDR_WIDTH)-1:0];
    initial $readmemh("C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/coe/ram.hex",ram, 0, ((2**ADDR_WIDTH)-1));
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ram[addr] <= 0;  // 使用非阻塞赋值清零
        end
        else if (we) begin
            if (sel == 4'b0001)
                ram[addr][7:0] <= d[7:0];
            else if (sel == 4'b0010)
                ram[addr][15:8] <= d[7:0];
            else if (sel == 4'b0100)
                ram[addr][23:16] <= d[7:0];
            else if (sel == 4'b1000)
                ram[addr][31:24] <= d[7:0];
            else if (sel == 4'b0011)
                ram[addr][15:0] <= d[15:0];
            else if (sel == 4'b1100)
                ram[addr][31:16] <= d[15:0];
            else
                ram[addr] <= d;
        end
    end
    
    assign dispColor = ram[dispAddr];
    assign q = ram[addr];
endmodule
