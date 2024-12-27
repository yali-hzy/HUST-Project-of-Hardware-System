`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 17:39:18
// Design Name: 
// Module Name: vga_tb
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


module vga_tb(

    );
  parameter WIDTH = 32;
  parameter ADDR_WIDTH = 16;
  reg clk=1;
  reg rst=0;
  wire start=1;
  reg GO=1;
  wire [3:0] VGA_R;
  wire [3:0] VGA_G;
  wire [3:0] VGA_B;
  wire VGA_HS;
  wire VGA_VS;
  wire [7:0] SEG;
  wire [7:0] AN;
  
  reg [2:0] IRQ = 3'b000;
  wire [3:0] BTN;
  reg rawclk = 1;

  initial begin
    GO = 0;
    clk = 1;
    rawclk = 1;
    IRQ = 3'b000;
    rst = 1;
    #20 rst = 0;
  end

  always #10 clk = ~clk;
  
  always #1 rawclk = ~rawclk;
  
  
  wire [WIDTH-1:0] LedData;
  
  wire [WIDTH-1:0] clocks;

//  counter Counter(clk, clocks);

  // always @(negedge clk) begin
  //   IRQ[0] <= (clocks == 'h0001 || clocks == 'h0258) ? 1 : 0;
  //   IRQ[1] <= (clocks == 'h0004) ? 1 : 0;
  //   IRQ[2] <= (clocks == 'h0007 || clocks == 'h0241) ? 1 : 0;
  // end

//  cpu #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) CPU_tb(rst, clk, GO, LedData, IRQ, IRW
//  , dispAddr, dispColor, rawclk
//  );

    interrupt_pipeline Interupt(start, rst, rawclk, GO, SEG, AN, IRQ, BTN
    , VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS
    )  ;
//    parameter SCREEN_WIDTH = 10;
//    wire [SCREEN_WIDTH-1:0] VGA_X;
//    wire [SCREEN_WIDTH-1:0] VGA_Y;
//    Vga vga(.clk_vga(clk), .rst(rst), .R(VGA_R), .G(VGA_G), .B(VGA_B), .HS(VGA_HS), .VS(VGS_VS), .x(VGA_X), .y(VGA_Y), .color(12'h222));
//    Vga vga(.clk(clk), .rst(rst), .red(VGA_R), .green(VGA_G), .blue(VGA_B), .hsync(VGA_HS), .vsync(VGS_VS), .next_x(VGA_X), .next_y(VGA_Y), .color_in(12'h222));
endmodule
