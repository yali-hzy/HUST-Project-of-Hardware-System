module ram(rst, clk, we, sel, addr, d, q);
    parameter ADDR_WIDTH = 10;
    parameter DATA_WIDTH = 32;
    input clk, we, rst;
    input [3:0] sel;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] d;
    output [DATA_WIDTH-1:0] q;
    reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];
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
    assign q = ram[addr];
endmodule