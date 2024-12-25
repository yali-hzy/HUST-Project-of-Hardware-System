module interrupt_pipeline(input start,
    input rst,
    input clk,
    input GO,
    output [7:0] SEG,
    output [7:0] AN,
    // (* clock_buffer_type="none" *) input [2:0] IRQ,
    input [3:0] BTN,
    output [2:0] IRW,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS,
    input flip,
    input [1:0] sel
);
    
    // input start;
    // input rst;
    // input clk;
    // input GO;
    // output [7:0] SEG;
    // output [7:0] AN;
    // (* clock_buffer_type="none" *) input [2:0] IRQ;
    // output [2:0] IRW;
    // output [3:0] VGA_R;
    // output [3:0] VGA_G;
    // output [3:0] VGA_B;
    // output VGA_HS;
    // output VGA_VS;
    
    
    
    wire CLK_p;
    wire CLK_05_p;
    wire CLK_4_p;
    wire clk_n2_p;
    wire clk_vga_p;
    wire clk_bram_p;
    wire CLK;
    wire CLK_05;
    wire CLK_4;
    wire clk_n2;
    wire clk_vga;
    wire clk_bram;
    
    parameter WIDTH = 32;
    parameter ADDR_WIDTH = 16;
    parameter SCREEN_WIDTH = 11;
    wire [WIDTH-1:0] LedData;
    
    wire [ADDR_WIDTH-1:0] dispAddr;
    wire [WIDTH-1:0] dispColor;
    
    
    divider #(.N(8)) CLK_N1(start, clk, CLK_p);
    divider #(.N(125_00_000)) CLK_N5(start, clk, CLK_4_p);
    divider #(.N(100_000_000)) CLK_N6(start, clk, CLK_05_p);
    divider #(.N(1)) CLK_N2(1'b1, clk, clk_n2_p);
    divider #(.N(2)) CLK_N3(1'b1, clk, clk_vga_p);
    divider #(.N(1)) CLK_N4(1'b1, clk, clk_bram_p);
    
    wire True_cpu_clk;
    
//    assign clk_bram_p = clk;    
//    BUFG bufg_CLK(.O(CLK), .I(CLK_p));
//    BUFG bufg_clkn2(.O(clk_n2), .I(clk_n2_p));
//    BUFG bufg_clk_vga(.O(clk_vga), .I(clk_vga_p));
//    BUFG bufg_clk_bram(.O(clk_bram), .I(clk_bram_p));

    assign CLK = CLK_p;
    assign clk_n2 = clk_n2_p;
    assign clk_vga = clk_vga_p;
    assign clk_bram = clk_bram_p;
    assign CLK_4 = CLK_4_p;
    assign CLK_05 = CLK_05_p;
//    assign True_cpu_clk = sel ? flip : CLK_p;
    mux41 #(.DATA_WIDTH(1))mux(CLK, CLK_4, flip, CLK_05, sel, True_cpu_clk);
    cpu #(.WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) CPU(rst, True_cpu_clk, GO, LedData, BTN, IRW
    , dispAddr, dispColor, clk_bram
    );
//    wire [WIDTH-1:0] Addr_Led;
//    assign Addr_Led = {16'b0, dispAddr};
    
   display #(.WIDTH(WIDTH)) DISPLAY(clk_n2, LedData, SEG, AN);
    
    
    
//    VGA
    wire [SCREEN_WIDTH-1:0] VGA_X, VGA_Y;
    wire [11:0] color;
//    Vga #(.SCREEN_WIDTH(SCREEN_WIDTH)) vga(.clk_vga(clk_vga), .rst(rst), .R(VGA_R), .G(VGA_G), .B(VGA_B), .HS(VGA_HS), .VS(VGA_VS), .x(vgaX), .y(vgaY), .color(color));
    Vga vga(.clk(clk_vga), .rst(rst), .red(VGA_R), .green(VGA_G), .blue(VGA_B), .hsync(VGA_HS), .vsync(VGA_VS), .next_x(VGA_X), .next_y(VGA_Y), .color_in(color));
//    wire [WIDTH-1:0] Info;
//    Screen #(.SCREEN_WIDTH(SCREEN_WIDTH)) screen(.color(color), .clk(clk_bram), .info(Info));
    
    GetScreenRam #(.ADDR_WIDTH(ADDR_WIDTH), .SCREEN_WIDTH(SCREEN_WIDTH)) getScreenRam(.rst(rst), .x(VGA_X), .y(VGA_Y), .addr(dispAddr), .data(dispColor), .color(color));
    
endmodule