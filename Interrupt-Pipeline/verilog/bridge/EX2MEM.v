module EX2MEM(clk, en, rst, RegWrite_in, RegWrite_out, WriteRegNo_in, WriteRegNo_out,
    MemToReg_in, MemToReg_out, MemWrite_in, MemWrite_out, LBU_in, LBU_out, 
    PC_in, PC_out, IR_in, IR_out, WriteData_in, WriteData_out, Result_in, Result_out, 
    ecall_in, ecall_out, a0_in, a0_out, a7_in, a7_out, 
    uret_in, uret_out, Int_Enter_in, Int_Enter_out, CSRWrite_in, CSRWrite_out,
    IEWrite_in, IEWrite_out, EPCWrite_in, EPCWrite_out, 
    IEWriteData_in, IEWriteData_out, EPCWriteData_in, EPCWriteData_out,
    IRS_in, IRS_out,
    LB_in, LB_out, LH_in, LH_out, LHU_in, LHU_out,
    SB_in, SB_out, SH_in, SH_out);

    parameter WIDTH = 32;
    input clk, en, rst;
    input RegWrite_in, MemToReg_in, MemWrite_in, LBU_in, ecall_in, 
        uret_in, Int_Enter_in, CSRWrite_in, IEWrite_in, EPCWrite_in, IEWriteData_in;
    input LB_in, LH_in, LHU_in, SB_in, SH_in;
    input [WIDTH-1:0] PC_in, IR_in, WriteData_in, Result_in, a0_in, a7_in, EPCWriteData_in;
    input [4:0] WriteRegNo_in;
    input [2:0] IRS_in;
    output RegWrite_out, MemToReg_out, MemWrite_out, LBU_out, ecall_out,
        uret_out, Int_Enter_out, CSRWrite_out, IEWrite_out, EPCWrite_out, IEWriteData_out;
    output LB_out, LH_out, LHU_out, SB_out, SH_out;
    output [WIDTH-1:0] PC_out, IR_out, WriteData_out, Result_out, a0_out, a7_out, EPCWriteData_out;
    output [4:0] WriteRegNo_out;
    output [2:0] IRS_out;

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
    sync_reset_reg #(.WIDTH(1)) uret_reg(clk, en, rst, uret_in, uret_out);
    sync_reset_reg #(.WIDTH(1)) Int_Enter_reg(clk, en, rst, Int_Enter_in, Int_Enter_out);
    sync_reset_reg #(.WIDTH(1)) CSRWrite_reg(clk, en, rst, CSRWrite_in, CSRWrite_out);
    sync_reset_reg #(.WIDTH(1)) IEWrite_reg(clk, en, rst, IEWrite_in, IEWrite_out);
    sync_reset_reg #(.WIDTH(1)) EPCWrite_reg(clk, en, rst, EPCWrite_in, EPCWrite_out);
    sync_reset_reg #(.WIDTH(1)) IEWriteData_reg(clk, en, rst, IEWriteData_in, IEWriteData_out);
    sync_reset_reg #(.WIDTH(WIDTH)) EPCWriteData_reg(clk, en, rst, EPCWriteData_in, EPCWriteData_out);
    sync_reset_reg #(.WIDTH(3)) IRS_reg(clk, en, rst, IRS_in, IRS_out);
    sync_reset_reg #(.WIDTH(1)) LB_reg(clk, en, rst, LB_in, LB_out);
    sync_reset_reg #(.WIDTH(1)) LH_reg(clk, en, rst, LH_in, LH_out);
    sync_reset_reg #(.WIDTH(1)) LHU_reg(clk, en, rst, LHU_in, LHU_out);
    sync_reset_reg #(.WIDTH(1)) SB_reg(clk, en, rst, SB_in, SB_out);
    sync_reset_reg #(.WIDTH(1)) SH_reg(clk, en, rst, SH_in, SH_out);

endmodule