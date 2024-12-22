module signal_generator (OP_CODE, Funct, MemToReg, MemWrite, ALU_SRC, RegWrite, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, CSRRSI, CSRRCI, CSRRW, 
                            LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC, 
                            CSRRC, CSRRS, CSRRWI);
    input [4:0] OP_CODE;
    input [4:0] Funct;
    output reg MemToReg, MemWrite, ALU_SRC, RegWrite, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, CSRRSI, CSRRCI, CSRRW;
    output reg LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC;
    output reg CSRRC, CSRRS, CSRRWI;
    
    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h0: begin
                case (Funct[2:0])
                3'b010: MemToReg = 1; // lw
                3'b100: MemToReg = 1; // lbu
                3'b000: MemToReg = 1; // lb
                3'b001: MemToReg = 1; // lh
                3'b101: MemToReg = 1; // lhu
                default: MemToReg = 0;
                endcase
            end
            default: MemToReg = 0;
        endcase
    end
    
    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h8: begin
                case (Funct[2:0])
                3'b010: MemWrite = 1; // sw
                3'b000: MemWrite = 1; // sb
                3'b001: MemWrite = 1; // sh
                default: MemWrite = 0;
                endcase
            end
            default: MemWrite = 0;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h4: begin
                case (Funct[2:0])
                3'b000: ALU_SRC = 1; // ADDI
                3'b111: ALU_SRC = 1; // ANDI
                3'b110: ALU_SRC = 1; // ORI
                3'b100: ALU_SRC = 1; // XORI
                3'b010: ALU_SRC = 1; // SLTI
                3'b011: ALU_SRC = 1; // SLTIU
                3'b001: if (Funct[4:3] == 2'b00) ALU_SRC = 1; else ALU_SRC = 0; // SLLI
                3'b101: if (Funct[4:3] == 2'b00) ALU_SRC = 1;  // SRLI
                        else if (Funct[4:3] == 2'b10) ALU_SRC = 1; else ALU_SRC = 0; // SRAI
                default: ALU_SRC = 0;
                endcase
            end
            'h0: begin
                case (Funct[2:0])
                3'b010: ALU_SRC = 1; // lw
                3'b100: ALU_SRC = 1; // lbu
                3'b000: ALU_SRC = 1; // lb
                3'b001: ALU_SRC = 1; // lh
                3'b101: ALU_SRC = 1; // lhu
                default: ALU_SRC = 0;
                endcase
            end
            'h8: begin
                case (Funct[2:0])
                3'b010: ALU_SRC = 1; // sw
                3'b000: ALU_SRC = 1; // sb
                3'b001: ALU_SRC = 1; // sh
                default: ALU_SRC = 0;
                endcase
            end
            'h1C: begin
                case (Funct[2:0])
                3'b110: ALU_SRC = 1; // CSRRSI
                3'b111: ALU_SRC = 1; // CSRRCI
                3'b101: ALU_SRC = 1; // CSRRWI
                default: ALU_SRC = 0;
                endcase
            end
            'h19: begin
                case (Funct[2:0])
                3'b000: ALU_SRC = 1; // JALR
                default: ALU_SRC = 0;
                endcase
            end
            default: ALU_SRC = 0;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'hC: begin
                case (Funct)
                5'b00000: RegWrite = 1; // ADD
                5'b10000: RegWrite = 1; // SUB
                5'b00111: RegWrite = 1; // AND
                5'b00110: RegWrite = 1; // OR
                5'b00010: RegWrite = 1; // SLT
                5'b00011: RegWrite = 1; // SLTU
                5'b00101: RegWrite = 1; // SRL
                5'b00001: RegWrite = 1; // SLL
                5'b00100: RegWrite = 1; // XOR
                5'b10101: RegWrite = 1; // SRA
                default: RegWrite = 0;
                endcase
            end
            'h0: begin
                case (Funct[2:0])
                3'b010: RegWrite = 1; // lw
                3'b100: RegWrite = 1; // lbu
                3'b000: RegWrite = 1; // lb
                3'b001: RegWrite = 1; // lh
                3'b101: RegWrite = 1; // lhu
                default: RegWrite = 0;
                endcase
            end
            'h4: begin
                case (Funct[2:0])
                3'b000: RegWrite = 1; // ADDI
                3'b111: RegWrite = 1; // ANDI
                3'b110: RegWrite = 1; // ORI
                3'b100: RegWrite = 1; // XORI
                3'b010: RegWrite = 1; // SLTI
                3'b011: RegWrite = 1; // SLTIU
                3'b001: if (Funct[4:3] == 2'b00) RegWrite = 1; else RegWrite = 0; // SLLI
                3'b101: if (Funct[4:3] == 2'b00) RegWrite = 1; // SRLI
                        else if (Funct[4:3] == 2'b10) RegWrite = 1; else RegWrite = 0; // SRAI
                default: RegWrite = 0;
                endcase
            end
            'h19: begin
                case (Funct[2:0])
                3'b000: RegWrite = 1; // JALR
                default: RegWrite = 0;
                endcase
            end
            'h1B: RegWrite = 1; // jal
            'h1C: begin
                case (Funct[2:0])
                3'b110: RegWrite = 1; // CSRRSI
                3'b111: RegWrite = 1; // CSRRCI
                3'b001: RegWrite = 1; // CSRRW
                3'b010: RegWrite = 1; // CSRRS
                3'b011: RegWrite = 1; // CSRRC
                3'b101: RegWrite = 1; // CSRRWI
                default: RegWrite = 0;
                endcase
            end
            'hD: RegWrite = 1; // lui
            'h5: RegWrite = 1; // auipc
            default: RegWrite = 0;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h1C: begin
                case (Funct)
                5'b00000: ecall = 1; // ecall
                default: ecall = 0;
                endcase
            end
            default: ecall = 0;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h8: begin
                case (Funct[2:0])
                3'b010: S_type = 1; // sw
                3'b000: S_type = 1; // sb
                3'b001: S_type = 1; // sh
                default: S_type = 0;
                endcase
            end
            default: S_type = 0;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h18: begin
                case (Funct[2:0])
                3'b000: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000100000; // beq
                3'b001: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000010000; // bne
                3'b110: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000001000; // bltu
                default: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000000;
                endcase
            end
            'h19: begin
                case (Funct[2:0])
                3'b000: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0100000000; // jalr
                default: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000000;
                endcase
            end
            'h1B: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b1000000000; // jal
            'hD: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0010000000; // lui
            'h1C: begin
                case (Funct[2:0])
                3'b110: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000100; // CSRRSI
                3'b111: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000010; // CSRRCI
                3'b001: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000001; // CSRRW
                default: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000000;
                endcase
            end
            'h0: begin
                case (Funct[2:0])
                3'b100: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0001000000; // LBU
                default: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000000;
                endcase
            end
            default: {JAL, Jalr, LUI, LBU, Beq, Bne, Bltu, CSRRSI, CSRRCI, CSRRW} = 10'b0000000000;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h0: begin
                case (Funct[2:0])
                3'b000: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b100000000; // lb
                3'b001: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b010000000; // lh
                3'b101: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b001000000; // lhu
                default: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000000;
                endcase
            end
            'h18: begin
                case (Funct[2:0])
                3'b100: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000100000; // blt
                3'b101: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000010000; // bge
                3'b111: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000001000; // bgeu
                default: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000000;
                endcase
            end
            'h8: begin
                case (Funct[2:0])
                3'b000: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000100; // sb
                3'b001: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000010; // sh
                default: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000000;
                endcase
            end
            'h5: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000001; // auipc
            default: {LB, LH, LHU, BLT, BGE, BGEU, SB, SH, AUIPC} = 9'b000000000;
        endcase
    end

    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h1C: begin
                case (Funct[2:0])
                3'b011: {CSRRC, CSRRS, CSRRWI} = 3'b100; // CSRRC
                3'b010: {CSRRC, CSRRS, CSRRWI} = 3'b010; // CSRRS
                3'b101: {CSRRC, CSRRS, CSRRWI} = 3'b001; // CSRRWI
                default: {CSRRC, CSRRS, CSRRWI} = 3'b000;
                endcase
            end
            default: {CSRRC, CSRRS, CSRRWI} = 3'b000;
        endcase
    end

endmodule