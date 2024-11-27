module interrupt_pipeline(start, rst, clk, GO, SEG, AN, IRQ, IRW);
    input start, rst, clk, GO;
    (* clock_buffer_type="none" *) input [2:0] IRQ;
    output[7:0] SEG;
    output[7:0] AN;
    output [2:0] IRW;
    wire CLK;
    wire clk_n2;
    parameter WIDTH = 32;
    
    wire [WIDTH-1:0] LedData;
    
    divider #(.N(5_000_000)) CLK_N1(start, rst, clk, CLK);
    divider #(.N(100_000)) CLK_N2(1, 0, clk, clk_n2);
    cpu #(.WIDTH(WIDTH)) CPU(rst, CLK, GO, LedData, IRQ, IRW);
    display #(.WIDTH(WIDTH)) DISPLAY(clk_n2, LedData, SEG, AN);
    
endmodule