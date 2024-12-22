`timescale 1ns / 1ps

module interrupt_pipeline_tb(

    );
  parameter WIDTH = 32;
  reg clk=1;
  reg rst=0;
  wire start=1;
  wire GO=0;
  
  reg [2:0] IRQ = 3'b000;
  wire [2:0] IRW;

  initial begin
    clk = 1;
    IRQ = 3'b000;
  
    #2 rst = 0;
  end

  always #5 clk = ~clk;
  
  wire [WIDTH-1:0] LedData;
  
  wire [WIDTH-1:0] clocks;

  counter Counter(clk, clocks);

  always @(negedge clk) begin
    IRQ[0] <= (clocks == 'h0001 || clocks == 'h0258) ? 1 : 0;
    IRQ[1] <= (clocks == 'h0004) ? 1 : 0;
    IRQ[2] <= (clocks == 'h0007 || clocks == 'h0241) ? 1 : 0;
  end

  cpu #(.WIDTH(WIDTH)) CPU_tb(rst, clk, GO, LedData, IRQ, IRW);
  
  
endmodule
