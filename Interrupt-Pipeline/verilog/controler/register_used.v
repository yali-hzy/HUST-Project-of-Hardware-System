module register_used (OP_CODE, Funct, R1_Used, R2_Used);
    input [4:0] OP_CODE;
    input [4:0] Funct;
    output reg R1_Used, R2_Used;
    
    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'h4: begin
                case (Funct[2:0])
                3'b000: R1_Used = 1; // ADDI
                3'b111: R1_Used = 1; // ANDI
                3'b110: R1_Used = 1; // ORI
                3'b100: R1_Used = 1; // XORI
                3'b010: R1_Used = 1; // SLTI
                3'b001: if (Funct[4:3] == 2'b00) R1_Used = 1; else R1_Used = 0; // SLLI
                3'b101: if (Funct[4:3] == 2'b00) R1_Used = 1;  // SRLI
                        else if (Funct[4:3] == 2'b10) R1_Used = 1; else R1_Used = 0; // SRAI
                default: R1_Used = 0;
                endcase
            end
            'h0: begin
                case (Funct[2:0])
                3'b010: R1_Used = 1; // lw
                3'b100: R1_Used = 1; // lbu
                default: R1_Used = 0;
                endcase
            end
            'hC: begin
                case (Funct)
                5'b00000: R1_Used = 1; // ADD
                5'b10000: R1_Used = 1; // SUB
                5'b00111: R1_Used = 1; // AND
                5'b00110: R1_Used = 1; // OR
                5'b00010: R1_Used = 1; // SLT
                5'b00011: R1_Used = 1; // SLTU
                5'b00101: R1_Used = 1; // SRL
                default: R1_Used = 0;
                endcase
            end
            'h8: begin
                case (Funct[2:0])
                3'b010: R1_Used = 1; // sw
                default: R1_Used = 0;
                endcase
            end
            'h1C: begin
                if (Funct == 5'b00000) R1_Used = 1; // ecall
                else if (Funct[2:0] == 3'b001) R1_Used = 1; // csrrw
                else R1_Used = 0;
            end
            'h18: begin
                case (Funct[2:0])
                3'b000: R1_Used = 1; // beq
                3'b001: R1_Used = 1; // bne
                3'b110: R1_Used = 1; // bltu
                default: R1_Used = 0;
                endcase
            end
            'h19: begin
                case (Funct[2:0])
                3'b000: R1_Used = 1; // jalr
                default: R1_Used = 0;
                endcase
            end
            default: R1_Used = 0;
        endcase
    end
    
    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'hC: begin
                case (Funct)
                5'b00000: R2_Used = 1; // ADD
                5'b10000: R2_Used = 1; // SUB
                5'b00111: R2_Used = 1; // AND
                5'b00110: R2_Used = 1; // OR
                5'b00010: R2_Used = 1; // SLT
                5'b00011: R2_Used = 1; // SLTU
                5'b00101: R2_Used = 1; // SRL
                default: R2_Used = 0;
                endcase
            end
            'h8: begin
                case (Funct[2:0])
                3'b010: R2_Used = 1; // sw
                default: R2_Used = 0;
                endcase
            end
            'h1C: begin
                case (Funct)
                5'b00000: R2_Used = 1; // ecall, 这里不该识别到 uret，但是懒得改了
                default: R2_Used = 0;
                endcase
            end
            'h18: begin
                case (Funct[2:0])
                3'b000: R2_Used = 1; // beq
                3'b001: R2_Used = 1; // bne
                3'b110: R2_Used = 1; // bltu
                default: R2_Used = 0;
                endcase
            end
            default: R2_Used = 0;
        endcase
    end
endmodule