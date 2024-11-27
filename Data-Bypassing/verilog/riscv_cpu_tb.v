`timescale 1ns / 1ps

module data_bypassing_tb(

    );
  parameter WIDTH = 32;
  reg clk=0;
  wire rst=0, start=1;
  // wire [7:0] SEG;
  // wire [7:0] AN;
  wire GO=0;
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  wire [WIDTH-1:0] LedData;
  
  // initial begin
  //   start = 0;
  //   rst = 0;
  //   #5 rst = 1;
  //   #12 rst = 0;
    
  //   #25 start = 1;
  // end

  cpu #(.WIDTH(WIDTH)) CPU_tb(rst, clk, GO, LedData);
  
  
endmodule
