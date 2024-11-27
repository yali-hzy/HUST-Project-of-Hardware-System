module IF2ID(clk, en, rst, PC_in, PC_out, IR_in, IR_out);
    parameter WIDTH = 32;
    input clk, en, rst;
    input [WIDTH-1:0] PC_in, IR_in;
    output [WIDTH-1:0] PC_out, IR_out;
    
    sync_reset_reg #(.WIDTH(WIDTH)) PC_reg(clk, en, rst, PC_in, PC_out);
    sync_reset_reg #(.WIDTH(WIDTH)) IR_reg(clk, en, rst, IR_in, IR_out);

endmodule