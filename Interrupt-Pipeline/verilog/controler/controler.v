module controler(OP_CODE, Funct, IR21, ALU_OP, MemToReg, MemWrite, ALU_SRC, RegWrite, uret, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, CSRRSI, CSRRCI, CSRRW, R1_Used, R2_Used);
    parameter WIDTH = 32;
    input [4:0] OP_CODE;
    input [4:0] Funct;
    input IR21;
    output [3:0] ALU_OP;
    output MemToReg, MemWrite, ALU_SRC, RegWrite, uret, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, CSRRSI, CSRRCI, CSRRW, R1_Used, R2_Used;
    
    alu_controler ALU_CONTROLER(OP_CODE, Funct, ALU_OP);

    wire ecalltmp;
    
    signal_generator SIGNAL_GENERATOR(OP_CODE, Funct, MemToReg, MemWrite, ALU_SRC, RegWrite, ecalltmp, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, CSRRSI, CSRRCI, CSRRW);

    assign uret = IR21 & ecalltmp;
    assign ecall = ~IR21 & ecalltmp;

    register_used REGISTER_USED(OP_CODE, Funct, R1_Used, R2_Used);

endmodule