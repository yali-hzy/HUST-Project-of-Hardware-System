module ID2EX(clk, en, rst, RegWrite_in, RegWrite_out, 
    WriteRegNo_in, WriteRegNo_out, MemToReg_in, MemToReg_out, MemWrite_in, MemWrite_out, 
    LBU_in, LBU_out, ALU_OP_in, ALU_OP_out, ALU_SrcB_in, ALU_SrcB_out, BEQ_in, BEQ_out,
    BNE_in, BNE_out, BLTU_in, BLTU_out, JAL_in, JAL_out, JALR_in, JALR_out, LUI_in, LUI_out,
    R1Forward_in, R1Forward_out, R2Forward_in, R2Forward_out, PC_in, PC_out, IR_in, IR_out,
    R1_in, R1_out, R2_in, R2_out, SignImm_in, SignImm_out, ecall_in, ecall_out, 
    CSRRCI_in, CSRRCI_out, CSRRSI_in, CSRRSI_out, CSRRW_in, CSRRW_out,
    Int_Enter_in, Int_Enter_out, uret_in, uret_out, CSRWrite_in, CSRWrite_out, 
    csr_in, csr_out, zimm_in, zimm_out, t_in, t_out, IRS_in, IRS_out, 
    LB_in, LB_out, LH_in, LH_out, LHU_in, LHU_out, 
    BLT_in, BLT_out, BGE_in, BGE_out, BGEU_in, BGEU_out, 
    SB_in, SB_out, SH_in, SH_out, 
    AUIPC_in, AUIPC_out, 
    CSRRC_in, CSRRC_out, CSRRS_in, CSRRS_out, CSRRWI_in, CSRRWI_out);

    parameter WIDTH = 32;
    input clk, en, rst;
    input RegWrite_in, MemToReg_in, MemWrite_in, LBU_in, ALU_SrcB_in, BEQ_in, BNE_in, BLTU_in, JAL_in, 
        JALR_in, LUI_in, ecall_in, CSRRCI_in, CSRRSI_in, CSRRW_in, Int_Enter_in, uret_in, CSRWrite_in;
    input LB_in, LH_in, LHU_in, BLT_in, BGE_in, BGEU_in, SB_in, SH_in, AUIPC_in;
    input CSRRC_in, CSRRS_in, CSRRWI_in;
    input [1:0] R1Forward_in, R2Forward_in;
    input [3:0] ALU_OP_in;
    input [WIDTH-1:0] PC_in, IR_in, R1_in, R2_in, SignImm_in, t_in;
    input [11:0] csr_in;
    input [4:0] WriteRegNo_in, zimm_in;
    input [2:0] IRS_in;
    output RegWrite_out, MemToReg_out, MemWrite_out, LBU_out, ALU_SrcB_out, BEQ_out, BNE_out, BLTU_out, JAL_out, 
        JALR_out, LUI_out, ecall_out, CSRRCI_out, CSRRSI_out, CSRRW_out, Int_Enter_out, uret_out, CSRWrite_out;
    output LB_out, LH_out, LHU_out, BLT_out, BGE_out, BGEU_out, SB_out, SH_out, AUIPC_out;
    output CSRRC_out, CSRRS_out, CSRRWI_out;
    output [1:0] R1Forward_out, R2Forward_out;
    output [3:0] ALU_OP_out;
    output [WIDTH-1:0] PC_out, IR_out, R1_out, R2_out, SignImm_out, t_out;
    output [11:0] csr_out;
    output [4:0] WriteRegNo_out, zimm_out;
    output [2:0] IRS_out;

    wire RST = rst | Int_Enter_in;

    sync_reset_reg #(.WIDTH(1)) RegWrite_reg(clk, en, RST, RegWrite_in, RegWrite_out);
    sync_reset_reg #(.WIDTH(5)) WriteRegNo_reg(clk, en, RST, WriteRegNo_in, WriteRegNo_out);
    sync_reset_reg #(.WIDTH(1)) MemToReg_reg(clk, en, RST, MemToReg_in, MemToReg_out);
    sync_reset_reg #(.WIDTH(1)) MemWrite_reg(clk, en, RST, MemWrite_in, MemWrite_out);
    sync_reset_reg #(.WIDTH(1)) LBU_reg(clk, en, RST, LBU_in, LBU_out);
    sync_reset_reg #(.WIDTH(4)) ALU_OP_reg(clk, en, RST, ALU_OP_in, ALU_OP_out);
    sync_reset_reg #(.WIDTH(1)) ALU_SrcB_reg(clk, en, RST, ALU_SrcB_in, ALU_SrcB_out);
    sync_reset_reg #(.WIDTH(1)) BEQ_reg(clk, en, RST, BEQ_in, BEQ_out);
    sync_reset_reg #(.WIDTH(1)) BNE_reg(clk, en, RST, BNE_in, BNE_out);
    sync_reset_reg #(.WIDTH(1)) BLTU_reg(clk, en, RST, BLTU_in, BLTU_out);
    sync_reset_reg #(.WIDTH(1)) JAL_reg(clk, en, RST, JAL_in, JAL_out);
    sync_reset_reg #(.WIDTH(1)) JALR_reg(clk, en, RST, JALR_in, JALR_out);
    sync_reset_reg #(.WIDTH(1)) LUI_reg(clk, en, RST, LUI_in, LUI_out);
    sync_reset_reg #(.WIDTH(2)) R1Forward_reg(clk, en, RST, R1Forward_in, R1Forward_out);
    sync_reset_reg #(.WIDTH(2)) R2Forward_reg(clk, en, RST, R2Forward_in, R2Forward_out);
    sync_reset_reg #(.WIDTH(WIDTH)) PC_reg(clk, en, rst, PC_in, PC_out);
    sync_reset_reg #(.WIDTH(WIDTH)) IR_reg(clk, en, rst, IR_in, IR_out);
    sync_reset_reg #(.WIDTH(WIDTH)) R1_reg(clk, en, RST, R1_in, R1_out);
    sync_reset_reg #(.WIDTH(WIDTH)) R2_reg(clk, en, RST, R2_in, R2_out);
    sync_reset_reg #(.WIDTH(WIDTH)) SignImm_reg(clk, en, RST, SignImm_in, SignImm_out);
    sync_reset_reg #(.WIDTH(1)) ecall_reg(clk, en, RST, ecall_in, ecall_out);
    sync_reset_reg #(.WIDTH(1)) CSRRCI_reg(clk, en, rst, CSRRCI_in, CSRRCI_out);
    sync_reset_reg #(.WIDTH(1)) CSRRSI_reg(clk, en, rst, CSRRSI_in, CSRRSI_out);
    sync_reset_reg #(.WIDTH(1)) CSRRW_reg(clk, en, rst, CSRRW_in, CSRRW_out);
    sync_reset_reg #(.WIDTH(1)) Int_Enter_reg(clk, en, rst, Int_Enter_in, Int_Enter_out);
    sync_reset_reg #(.WIDTH(1)) uret_reg(clk, en, rst, uret_in, uret_out);
    sync_reset_reg #(.WIDTH(1)) CSRWrite_reg(clk, en, rst, CSRWrite_in, CSRWrite_out);
    sync_reset_reg #(.WIDTH(12)) csr_reg(clk, en, rst, csr_in, csr_out);
    sync_reset_reg #(.WIDTH(5)) zimm_reg(clk, en, rst, zimm_in, zimm_out);
    sync_reset_reg #(.WIDTH(WIDTH)) t_reg(clk, en, rst, t_in, t_out);
    sync_reset_reg #(.WIDTH(3)) IRS_reg(clk, en, rst, IRS_in, IRS_out);
    sync_reset_reg #(.WIDTH(1)) LB_reg(clk, en, rst, LB_in, LB_out);
    sync_reset_reg #(.WIDTH(1)) LH_reg(clk, en, rst, LH_in, LH_out);
    sync_reset_reg #(.WIDTH(1)) LHU_reg(clk, en, rst, LHU_in, LHU_out);
    sync_reset_reg #(.WIDTH(1)) BLT_reg(clk, en, rst, BLT_in, BLT_out);
    sync_reset_reg #(.WIDTH(1)) BGE_reg(clk, en, rst, BGE_in, BGE_out);
    sync_reset_reg #(.WIDTH(1)) BGEU_reg(clk, en, rst, BGEU_in, BGEU_out);
    sync_reset_reg #(.WIDTH(1)) SB_reg(clk, en, rst, SB_in, SB_out);
    sync_reset_reg #(.WIDTH(1)) SH_reg(clk, en, rst, SH_in, SH_out);
    sync_reset_reg #(.WIDTH(1)) AUIPC_reg(clk, en, rst, AUIPC_in, AUIPC_out);
    sync_reset_reg #(.WIDTH(1)) CSRRC_reg(clk, en, rst, CSRRC_in, CSRRC_out);
    sync_reset_reg #(.WIDTH(1)) CSRRS_reg(clk, en, rst, CSRRS_in, CSRRS_out);
    sync_reset_reg #(.WIDTH(1)) CSRRWI_reg(clk, en, rst, CSRRWI_in, CSRRWI_out);

endmodule