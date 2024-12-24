module rom_text(read_addr, data, rawclk);
  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 10;
  localparam TRUE_ADDR_WIDTH = 16;
  input rawclk;
  input [ADDR_WIDTH-1:0] read_addr;
  output [DATA_WIDTH-1:0] data;

  //reg [DATA_WIDTH-1:0] rom[0:((2**ADDR_WIDTH)-1)];

//  initial $readmemh("C:/Users/13183/Documents/cc_exp/HUST-Project-of-Hardware-System/Interrupt-Pipeline/verilog/risc-v-nested_interrupt.hex",rom, 0, ((2**ADDR_WIDTH)-1));

// initial $readmemh("C:/Users/13183/Documents/cc_exp/hex/SB.hex", rom, 0, ((2**ADDR_WIDTH)-1));

//  initial $readmemh("D:/Users/hzy/Desktop/HUST/course/Hardware/Interrupt-Pipeline/verilog/magic_cube.hex",rom, 0, ((2**ADDR_WIDTH)-1));

  brom rom(.addra(read_addr[TRUE_ADDR_WIDTH-1:0]), .clka(rawclk), .douta(data));
//  assign data = rom[read_addr];
endmodule

