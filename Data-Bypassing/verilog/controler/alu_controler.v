module alu_controler (OP_CODE, Funct, ALU_OP);
    input [4:0] OP_CODE;
    input [4:0] Funct;
    output reg [3:0] ALU_OP;
    
    always @(OP_CODE, Funct) begin
        case (OP_CODE)
            'hC: begin
                case (Funct)
                5'b00000: ALU_OP = 5; // ADD
                5'b10000: ALU_OP = 6; // SUB
                5'b00111: ALU_OP = 7; // AND
                5'b00110: ALU_OP = 8; // OR
                5'b00010: ALU_OP = 11; // SLT
                5'b00011: ALU_OP = 12; // SLTU
                5'b00101: ALU_OP = 2; // SRL
                default: ALU_OP = 0;
                endcase
            end
            'h4: begin
                case (Funct[2:0])
                3'b000: ALU_OP = 5; // ADDI
                3'b111: ALU_OP = 7; // ANDI
                3'b110: ALU_OP = 8; // ORI
                3'b100: ALU_OP = 9; // XORI
                3'b010: ALU_OP = 11; // SLTI
                3'b001: if (Funct[4:3] == 2'b00) ALU_OP = 0; else ALU_OP = 0; // SLLI
                3'b101: if (Funct[4:3] == 2'b00) ALU_OP = 2; // SRLI
                        else if (Funct[4:3] == 2'b10) ALU_OP = 1; // SRAI
                        else ALU_OP = 0;
                default: ALU_OP = 0;
                endcase
            end
            'h19: begin
                case (Funct[2:0])
                3'b000: ALU_OP = 5; // JALR
                default: ALU_OP = 0;
                endcase
            end
            'h1C: begin
                case (Funct[2:0])
                3'b110: ALU_OP = 8; // CSRRSI
                3'b111: ALU_OP = 7; // CSRRCI
                default: ALU_OP = 0;
                endcase
            end
            'h18: begin
                case (Funct[2:0])
                3'b110: ALU_OP = 12; // bltu
                default: ALU_OP = 0;
                endcase
            end
            'h0: begin
                case (Funct[2:0])
                3'b010: ALU_OP = 5; // lw
                3'b100: ALU_OP = 5; // lbu
                default: ALU_OP = 0;
                endcase
            end
            'h8: begin
                case (Funct[2:0])
                3'b010: ALU_OP = 5; // sw
                default: ALU_OP = 0;
                endcase
            end
            default: ALU_OP = 0;
        endcase
    end

endmodule