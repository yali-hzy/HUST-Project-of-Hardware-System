`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/23 23:48:25
// Design Name: 
// Module Name: GetScreenColor_tb
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


module GetScreenColor_tb(

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
  wire [ADDR_WIDTH-1:0] dispAddr;
  reg [32:0] dispColor;
  wire [11:0] color;
  reg [2:0] IRQ = 3'b000;
  wire [2:0] IRW;
  reg rawclk = 1;
  parameter SCREEN_WIDTH = 11;
  reg [SCREEN_WIDTH-1:0] VGA_X;
  reg [SCREEN_WIDTH-1:0] VGA_Y;
  initial begin
    GO = 0;
    clk = 1;
    rawclk = 1;
    IRQ = 3'b000;
    rst = 1;
//    dispAddr = 0;
    #2 rst = 0;
    
    #20 VGA_X = 11'h100;
        VGA_Y = 11'h078;
        dispColor = 32'h12345678;
        
    #20 VGA_X = 11'h101;
        VGA_Y = 11'h072;
        dispColor = 32'h12345678;
        
    #20 VGA_X = 11'h103;
        VGA_Y = 11'h085;
        dispColor = 32'h12345678;
    
  end

  always #10 clk = ~clk;
  
  always #1 rawclk = ~rawclk;
  
  
  wire [WIDTH-1:0] LedData;
  
  wire [WIDTH-1:0] clocks;
  
  GetScreenRam getScreenRam(.x(VGA_X), .y(VGA_Y), .addr(dispAddr), .data(dispColor), .color(color));

//  counter Counter(clk, clocks);

  // always @(negedge clk) begin
  //   IRQ[0] <= (clocks == 'h0001 || clocks == 'h0258) ? 1 : 0;
  //   IRQ[1] <= (clocks == 'h0004) ? 1 : 0;
  //   IRQ[2] <= (clocks == 'h0007 || clocks == 'h0241) ? 1 : 0;
  // end

//  cpu #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) CPU_tb(rst, clk, GO, LedData, IRQ, IRW
//  , dispAddr, dispColor, rawclk
//  );

//    interrupt_pipeline Interupt(start, rst, rawclk, GO, SEG, AN, IRQ, IRW
//    , VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS
//    )  ;
//    
//    
//    Vga vga(.clk_vga(clk), .rst(rst), .R(VGA_R), .G(VGA_G), .B(VGA_B), .HS(VGA_HS), .VS(VGS_VS), .x(VGA_X), .y(VGA_Y), .color(12'h222));
//    Vga vga(.clk(clk), .rst(rst), .red(VGA_R), .green(VGA_G), .blue(VGA_B), .hsync(VGA_HS), .vsync(VGS_VS), .next_x(VGA_X), .next_y(VGA_Y), .color_in(12'h222));
endmodule
