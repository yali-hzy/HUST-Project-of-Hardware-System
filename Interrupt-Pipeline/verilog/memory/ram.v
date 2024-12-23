module ram(rst, clk, we, sel, addr, d, q
, dispAddr, dispColor, rawclk
);
    parameter ADDR_WIDTH = 10;
    parameter DATA_WIDTH = 32;
    input clk, we, rst, rawclk;
    input [3:0] sel;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] d;
    input [ADDR_WIDTH-1:0] dispAddr;
    output [DATA_WIDTH-1:0] q;
    output [DATA_WIDTH-1:0] dispColor;
    reg [DATA_WIDTH-1:0] ram[0:2**(ADDR_WIDTH-5)];
    integer i;

    initial begin
        for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
            ram[i] <= 0;
        end
    end
    
    
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // for (i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
            //     ram[i] <= 0;
            // end
            ram[addr] <= 0;
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
    
//    bram0 mem0(.clka(clk), .dina(d[7:0]), .douta(q[7:0]), .addra(addr), .wea(sel[0] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[7:0]), .ena(1), .enb(1));
//    bram1 mem1(.clka(clk), .dina(d[15:8]), .douta(q[15:8]), .addra(addr), .wea(sel[1] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[15:8]), .ena(1), .enb(1));
//    bram2 mem2(.clka(clk), .dina(d[23:16]), .douta(q[23:16]), .addra(addr), .wea(sel[2] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[23:16]), .ena(1), .enb(1));
//    bram3 mem3(.clka(clk), .dina(d[31:24]), .douta(q[31:24]), .addra(addr), .wea(sel[3] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[31:24]), .ena(1), .enb(1));

//    bram0_16 mem0(.clka(clk), .dina(d[7:0]), .douta(q[7:0]), .addra(addr), .wea(sel[0] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[7:0]), .ena(1), .enb(1), .dinb(0), .web(0));
//    bram1_16 mem1(.clka(clk), .dina(d[15:8]), .douta(q[15:8]), .addra(addr), .wea(sel[1] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[15:8]), .ena(1), .enb(1), .dinb(0), .web(0));
//    bram2_16 mem2(.clka(clk), .dina(d[23:16]), .douta(q[23:16]), .addra(addr), .wea(sel[2] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[23:16]), .ena(1), .enb(1), .dinb(0), .web(0));
//    bram3_16 mem3(.clka(clk), .dina(d[31:24]), .douta(q[31:24]), .addra(addr), .wea(sel[3] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[31:24]), .ena(1), .enb(1), .dinb(0), .web(0));

    assign dispColor = ram[dispAddr];
    assign q = ram[addr];
endmodule