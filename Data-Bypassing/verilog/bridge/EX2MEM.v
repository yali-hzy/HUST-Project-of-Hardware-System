module EX2MEM(clk, en, rst, RegWrite_in, RegWrite_out, WriteRegNo_in, WriteRegNo_out,
    MemToReg_in, MemToReg_out, MemWrite_in, MemWrite_out, LBU_in, LBU_out, 
    PC_in, PC_out, IR_in, IR_out, WriteData_in, WriteData_out, Result_in, Result_out, 
    ecall_in, ecall_out, a0_in, a0_out, a7_in, a7_out);

    parameter WIDTH = 32;
    input clk, en, rst;
    input RegWrite_in, MemToReg_in, MemWrite_in, LBU_in, ecall_in;
    input [WIDTH-1:0] PC_in, IR_in, WriteData_in, Result_in, a0_in, a7_in;
    input [4:0] WriteRegNo_in;
    output RegWrite_out, MemToReg_out, MemWrite_out, LBU_out, ecall_out;
    output [WIDTH-1:0] PC_out, IR_out, WriteData_out, Result_out, a0_out, a7_out;
    output [4:0] WriteRegNo_out;

    sync_reset_reg #(.WIDTH(1)) RegWrite_reg(clk, en, rst, RegWrite_in, RegWrite_out);
    sync_reset_reg #(.WIDTH(5)) WriteRegNo_reg(clk, en, rst, WriteRegNo_in, WriteRegNo_out);
    sync_reset_reg #(.WIDTH(1)) MemToReg_reg(clk, en, rst, MemToReg_in, MemToReg_out);
    sync_reset_reg #(.WIDTH(1)) MemWrite_reg(clk, en, rst, MemWrite_in, MemWrite_out);
    sync_reset_reg #(.WIDTH(1)) LBU_reg(clk, en, rst, LBU_in, LBU_out);
    sync_reset_reg #(.WIDTH(WIDTH)) PC_reg(clk, en, rst, PC_in, PC_out);
    sync_reset_reg #(.WIDTH(WIDTH)) IR_reg(clk, en, rst, IR_in, IR_out);
    sync_reset_reg #(.WIDTH(WIDTH)) WriteData_reg(clk, en, rst, WriteData_in, WriteData_out);
    sync_reset_reg #(.WIDTH(WIDTH)) Result_reg(clk, en, rst, Result_in, Result_out);
    sync_reset_reg #(.WIDTH(1)) ecall_reg(clk, en, rst, ecall_in, ecall_out);
    sync_reset_reg #(.WIDTH(WIDTH)) a0_reg(clk, en, rst, a0_in, a0_out);
    sync_reset_reg #(.WIDTH(WIDTH)) a7_reg(clk, en, rst, a7_in, a7_out);

endmodule