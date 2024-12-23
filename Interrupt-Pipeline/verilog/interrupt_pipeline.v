module interrupt_pipeline(start, rst, clk, GO, SEG, AN, IRQ, IRW
, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS
);
    
    input start, rst, clk, GO;
    (* clock_buffer_type="none" *) input [2:0] IRQ;
    
    output [3:0] VGA_R;
    output [3:0] VGA_G;
    output [3:0] VGA_B;
    output VGA_HS;
    output VGA_VS;
    output [7:0] SEG;
    output [7:0] AN;
    output [2:0] IRW;
    
    
    wire CLK;
    wire clk_n2;
    parameter WIDTH = 32;
    parameter ADDR_WIDTH = 16;
    parameter SCREEN_WIDTH = 10;
    wire [WIDTH-1:0] LedData;
    
    wire [ADDR_WIDTH-1:0] dispAddr;
    wire [WIDTH-1:0] dispColor;
    
    
    divider #(.N(5_000_000)) CLK_N1(start, rst, clk, CLK);
    divider #(.N(100_000)) CLK_N2(1, 0, clk, clk_n2);
    cpu #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) CPU(rst, CLK, GO, LedData, IRQ, IRW
    , dispAddr, dispColor, clk
    );
    display #(.WIDTH(WIDTH)) DISPLAY(clk_n2, LedData, SEG, AN);
    
    
//    VGA
//    wire [SCREEN_WIDTH-1:0] vgaX, vgaY;
//    wire [11:0] color;
//    Vga #(.SCREEN_WIDTH(SCREEN_WIDTH)) vga(.rawClk(clk), .rst(rst), .R(VGA_R), .G(VGA_G), .B(VGA_B), .HS(VGA_HS), .VS(VGA_VS), .x(vgaX), .y(vgaY), .color(color));
//    wire [WIDTH-1:0] Info;
//    Screen #(.SCREEN_WIDTH(SCREEN_WIDTH)) screen(.color(color), .clk(clk), .info(Info));
    
//    GetScreenRam #(.ADDR_WIDTH(ADDR_WIDTH), .SCREEN_WIDTH(SCREEN_WIDTH)) getScreenRam(.clk(clk), .x(vgaX), .y(vgaY), .addr(dispAddr), .data(dispColor), .Info(Info));
    
endmodule