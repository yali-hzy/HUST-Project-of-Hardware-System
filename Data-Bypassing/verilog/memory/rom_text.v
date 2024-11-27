module rom_text(read_addr, data);
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;

  input [ADDR_WIDTH-1:0] read_addr;
  output [DATA_WIDTH-1:0] data;

  reg [DATA_WIDTH-1:0] rom[0:((2**ADDR_WIDTH)-1)];

  initial $readmemh("D:/Users/hzy/Desktop/HUST/course/Hardware/Data-Bypassing/verilog/risc-v-benchmark_ccab.hex",rom, 0, ((2**ADDR_WIDTH)-1));

  assign data = rom[read_addr];
endmodule

