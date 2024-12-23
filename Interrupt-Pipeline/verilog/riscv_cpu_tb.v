`timescale 1ns / 1ps

module interrupt_pipeline_tb(

    );
  parameter WIDTH = 32;
  parameter ADDR_WIDTH = 16;
  reg clk=1;
  reg rst=0;
  wire start=1;
  reg GO=1;
  reg [3:0] VGA_R;
  reg [3:0] VGA_G;
  reg [3:0] VGA_B;
  reg VGA_HS;
  reg VGA_VS;
  reg [7:0] SEG;
  reg [7:0] AN;
  reg [16:0] dispAddr;
  wire [32:0] dispColor;
  
  reg [2:0] IRQ = 3'b000;
  wire [2:0] IRW;
  reg rawclk = 1;

  initial begin
    GO = 1;
    clk = 1;
    rawclk = 1;
    IRQ = 3'b000;
    rst = 1;
    dispAddr = 0;
    #2 rst = 0;
  end

  always #10 clk = ~clk;
  
  always #1 rawclk = ~rawclk;
  
  
  wire [WIDTH-1:0] LedData;
  
  wire [WIDTH-1:0] clocks;

  counter Counter(clk, clocks);

  // always @(negedge clk) begin
  //   IRQ[0] <= (clocks == 'h0001 || clocks == 'h0258) ? 1 : 0;
  //   IRQ[1] <= (clocks == 'h0004) ? 1 : 0;
  //   IRQ[2] <= (clocks == 'h0007 || clocks == 'h0241) ? 1 : 0;
  // end

  cpu #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) CPU_tb(rst, clk, GO, LedData, IRQ, IRW
  , dispAddr, dispColor, rawclk
  );

//    interrupt_pipeline Interupt(start, rst, clk, GO, SEG, AN, IRQ, IRW
//    , VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS
//    )  ;
  
endmodule
