module MEM2WB(clk, en, rst, RegWrite_in, RegWrite_out, WriteRegNo_in, WriteRegNo_out,
    MemToReg_in, MemToReg_out, PC_in, PC_out, IR_in, IR_out, 
    MemData_in, MemData_out, ALU_Result_in, ALU_Result_out, 
    ecall_in, ecall_out, a0_in, a0_out, a7_in, a7_out, 
    uret_in, uret_out, Int_Enter_in, Int_Enter_out, CSRWrite_in, CSRWrite_out,
    IEWrite_in, IEWrite_out, EPCWrite_in, EPCWrite_out, 
    IEWriteData_in, IEWriteData_out, EPCWriteData_in, EPCWriteData_out, 
    IRS_in, IRS_out, 
    CAUSEWrite_in, CAUSEWrite_out, CAUSEWriteData_in, CAUSEWriteData_out);

    parameter WIDTH = 32;
    input clk, en, rst;
    input RegWrite_in, MemToReg_in, ecall_in, 
        uret_in, Int_Enter_in, CSRWrite_in, IEWrite_in, EPCWrite_in, IEWriteData_in;
    input CAUSEWrite_in;
    input [WIDTH-1:0] PC_in, IR_in, MemData_in, ALU_Result_in, a0_in, a7_in, EPCWriteData_in;
    input [WIDTH-1:0] CAUSEWriteData_in;
    input [4:0] WriteRegNo_in;
    input [2:0] IRS_in;
    output RegWrite_out, MemToReg_out, ecall_out, 
        uret_out, Int_Enter_out, CSRWrite_out, IEWrite_out, EPCWrite_out, IEWriteData_out;
    output CAUSEWrite_out;
    output [WIDTH-1:0] PC_out, IR_out, MemData_out, ALU_Result_out, a0_out, a7_out, EPCWriteData_out;
    output [WIDTH-1:0] CAUSEWriteData_out;
    output [4:0] WriteRegNo_out;
    output [2:0] IRS_out;

    sync_reset_reg #(.WIDTH(1)) RegWrite_reg(clk, en, rst, RegWrite_in, RegWrite_out);
    sync_reset_reg #(.WIDTH(5)) WriteRegNo_reg(clk, en, rst, WriteRegNo_in, WriteRegNo_out);
    sync_reset_reg #(.WIDTH(1)) MemToReg_reg(clk, en, rst, MemToReg_in, MemToReg_out);
    sync_reset_reg #(.WIDTH(WIDTH)) PC_reg(clk, en, rst, PC_in, PC_out);
    sync_reset_reg #(.WIDTH(WIDTH)) IR_reg(clk, en, rst, IR_in, IR_out);
    sync_reset_reg #(.WIDTH(WIDTH)) MemData_reg(clk, en, rst, MemData_in, MemData_out);
    sync_reset_reg #(.WIDTH(WIDTH)) ALU_Result_reg(clk, en, rst, ALU_Result_in, ALU_Result_out);
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
    sync_reset_reg #(.WIDTH(1)) CAUSEWrite_reg(clk, en, rst, CAUSEWrite_in, CAUSEWrite_out);
    sync_reset_reg #(.WIDTH(WIDTH)) CAUSEWriteData_reg(clk, en, rst, CAUSEWriteData_in, CAUSEWriteData_out);

endmodule