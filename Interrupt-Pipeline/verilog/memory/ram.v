module ram(rst, clk, we, addr, d, q, dispAddr, dispColor);
    parameter ADDR_WIDTH = 10;
    parameter DATA_WIDTH = 32;
    input clk, we, rst;
    input [ADDR_WIDTH-1:0] addr;
    input [DATA_WIDTH-1:0] d;
    input [ADDR_WIDTH-1:0] dispAddr;
    output [DATA_WIDTH-1:0] q;
    output [DATA_WIDTH-1:0] dispColor;
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
            ram[addr] <= d;
        end
    end
    assign dispColor = ram[dispAddr];
    assign q = ram[addr];
endmodule