module ID2EX(clk, en, rst, RegWrite_in, RegWrite_out, 
    WriteRegNo_in, WriteRegNo_out, MemToReg_in, MemToReg_out, MemWrite_in, MemWrite_out, 
    LBU_in, LBU_out, ALU_OP_in, ALU_OP_out, ALU_SrcB_in, ALU_SrcB_out, BEQ_in, BEQ_out,
    BNE_in, BNE_out, BLTU_in, BLTU_out, JAL_in, JAL_out, JALR_in, JALR_out, LUI_in, LUI_out,
    R1Forward_in, R1Forward_out, R2Forward_in, R2Forward_out, PC_in, PC_out, IR_in, IR_out,
    R1_in, R1_out, R2_in, R2_out, SignImm_in, SignImm_out, ecall_in, ecall_out);

    parameter WIDTH = 32;
    input clk, en, rst;
    input RegWrite_in, MemToReg_in, MemWrite_in, LBU_in, ALU_SrcB_in, BEQ_in, BNE_in, BLTU_in, JAL_in, JALR_in, LUI_in, ecall_in;
    input [1:0] R1Forward_in, R2Forward_in;
    input [3:0] ALU_OP_in;
    input [WIDTH-1:0] PC_in, IR_in, R1_in, R2_in, SignImm_in;
    input [4:0] WriteRegNo_in;
    output RegWrite_out, MemToReg_out, MemWrite_out, LBU_out, ALU_SrcB_out, BEQ_out, BNE_out, BLTU_out, JAL_out, JALR_out, LUI_out, ecall_out;
    output [1:0] R1Forward_out, R2Forward_out;
    output [3:0] ALU_OP_out;
    output [WIDTH-1:0] PC_out, IR_out, R1_out, R2_out, SignImm_out;
    output [4:0] WriteRegNo_out;

    sync_reset_reg #(.WIDTH(1)) RegWrite_reg(clk, en, rst, RegWrite_in, RegWrite_out);
    sync_reset_reg #(.WIDTH(5)) WriteRegNo_reg(clk, en, rst, WriteRegNo_in, WriteRegNo_out);
    sync_reset_reg #(.WIDTH(1)) MemToReg_reg(clk, en, rst, MemToReg_in, MemToReg_out);
    sync_reset_reg #(.WIDTH(1)) MemWrite_reg(clk, en, rst, MemWrite_in, MemWrite_out);
    sync_reset_reg #(.WIDTH(1)) LBU_reg(clk, en, rst, LBU_in, LBU_out);
    sync_reset_reg #(.WIDTH(4)) ALU_OP_reg(clk, en, rst, ALU_OP_in, ALU_OP_out);
    sync_reset_reg #(.WIDTH(1)) ALU_SrcB_reg(clk, en, rst, ALU_SrcB_in, ALU_SrcB_out);
    sync_reset_reg #(.WIDTH(1)) BEQ_reg(clk, en, rst, BEQ_in, BEQ_out);
    sync_reset_reg #(.WIDTH(1)) BNE_reg(clk, en, rst, BNE_in, BNE_out);
    sync_reset_reg #(.WIDTH(1)) BLTU_reg(clk, en, rst, BLTU_in, BLTU_out);
    sync_reset_reg #(.WIDTH(1)) JAL_reg(clk, en, rst, JAL_in, JAL_out);
    sync_reset_reg #(.WIDTH(1)) JALR_reg(clk, en, rst, JALR_in, JALR_out);
    sync_reset_reg #(.WIDTH(1)) LUI_reg(clk, en, rst, LUI_in, LUI_out);
    sync_reset_reg #(.WIDTH(2)) R1Forward_reg(clk, en, rst, R1Forward_in, R1Forward_out);
    sync_reset_reg #(.WIDTH(2)) R2Forward_reg(clk, en, rst, R2Forward_in, R2Forward_out);
    sync_reset_reg #(.WIDTH(WIDTH)) PC_reg(clk, en, rst, PC_in, PC_out);
    sync_reset_reg #(.WIDTH(WIDTH)) IR_reg(clk, en, rst, IR_in, IR_out);
    sync_reset_reg #(.WIDTH(WIDTH)) R1_reg(clk, en, rst, R1_in, R1_out);
    sync_reset_reg #(.WIDTH(WIDTH)) R2_reg(clk, en, rst, R2_in, R2_out);
    sync_reset_reg #(.WIDTH(WIDTH)) SignImm_reg(clk, en, rst, SignImm_in, SignImm_out);
    sync_reset_reg #(.WIDTH(1)) ecall_reg(clk, en, rst, ecall_in, ecall_out);

endmodule