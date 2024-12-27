module ram(rst, we, sel, addr, d, q
, dispAddr, dispColor, rawclk
);
    parameter ADDR_WIDTH = 10;
    parameter DATA_WIDTH = 32;
    input we, rst, rawclk;
    input [3:0] sel;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] d;
    input [ADDR_WIDTH-1:0] dispAddr;
    output [DATA_WIDTH-1:0] q;
//    wire [DATA_WIDTH-1:0] q;
    output [DATA_WIDTH-1:0] dispColor;
    reg [DATA_WIDTH-1:0] ram;
    
    always @(posedge (rawclk) or posedge rst) begin
        if (rst) begin
            ram <= 0;  // 使用非阻塞赋值清零
        end
        else if (we) begin
            if (sel == 4'b0001)
                ram[7:0] <= d[7:0];
            else if (sel == 4'b0010)
                ram[15:8] <= d[7:0];
            else if (sel == 4'b0100)
                ram[23:16] <= d[7:0];
            else if (sel == 4'b1000)
                ram[31:24] <= d[7:0];
            else if (sel == 4'b0011)
                ram[15:0] <= d[15:0];
            else if (sel == 4'b1100)
                ram[31:16] <= d[15:0];
            else
                ram <= d;
        end
    end
    
//    bram0 mem0(.clka(clk), .dina(d[7:0]), .douta(q[7:0]), .addra(addr), .wea(sel[0] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[7:0]), .ena(1), .enb(1));
//    bram1 mem1(.clka(clk), .dina(d[15:8]), .douta(q[15:8]), .addra(addr), .wea(sel[1] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[15:8]), .ena(1), .enb(1));
//    bram2 mem2(.clka(clk), .dina(d[23:16]), .douta(q[23:16]), .addra(addr), .wea(sel[2] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[23:16]), .ena(1), .enb(1));
//    bram3 mem3(.clka(clk), .dina(d[31:24]), .douta(q[31:24]), .addra(addr), .wea(sel[3] & we), .clkb(rawclk), .addrb(dispAddr), .doutb(dispColor[31:24]), .ena(1), .enb(1));

    wire [7:0] dina0, dina1, dina2, dina3;
    assign dina0 = ram[7:0];
    assign dina1 = ram[15:8];
    assign dina2 = ram[23:16];
    assign dina3 = ram[31:24];

    wire [7:0] douta0, douta1, douta2, douta3;
    wire wea0, wea1, wea2, wea3;
    assign wea0 = sel[0] & we;
    assign wea1 = sel[1] & we;
    assign wea2 = sel[2] & we;
    assign wea3 = sel[3] & we;

    wire [7:0] doutb0, doutb1, doutb2, doutb3;

    bram0_16 mem0(.clka(rawclk), .dina(dina0), .douta(douta0), .addra(addr), .wea(wea0), .clkb(rawclk), .addrb(dispAddr), .doutb(doutb0), .dinb(8'b0), .web(1'b0));
    bram1_16 mem1(.clka(rawclk), .dina(dina1), .douta(douta1), .addra(addr), .wea(wea1), .clkb(rawclk), .addrb(dispAddr), .doutb(doutb1), .dinb(8'b0), .web(1'b0));
    bram2_16 mem2(.clka(rawclk), .dina(dina2), .douta(douta2), .addra(addr), .wea(wea2), .clkb(rawclk), .addrb(dispAddr), .doutb(doutb2), .dinb(8'b0), .web(1'b0));
    bram3_16 mem3(.clka(rawclk), .dina(dina3), .douta(douta3), .addra(addr), .wea(wea3), .clkb(rawclk), .addrb(dispAddr), .doutb(doutb3), .dinb(8'b0), .web(1'b0));

    assign q = {douta3, douta2, douta1, douta0};
    assign dispColor = {doutb3, doutb2, doutb1, doutb0};
//    assign dispColor = ram[dispAddr];
//    assign Q = q;
endmodule