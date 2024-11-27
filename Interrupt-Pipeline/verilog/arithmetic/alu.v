module alu (A, B, ALUOp, Result1, Result2, Equal, LT, GE);
    parameter WIDTH = 32;
    input signed [WIDTH-1:0] A, B;
    input [3:0] ALUOp;
    output reg signed [WIDTH-1:0] Result1, Result2;
    output reg Equal, LT, GE;
    
    always @(*) begin
        case (ALUOp)
            4'b0000: begin
                Result1 = A << B[4:0];
                Result2 = 0;
            end
            4'b0001: begin
                Result1 = A >>> B[4:0];
                Result2 = 0;
            end
            4'b0010: begin
                Result1 = A >> B[4:0];
                Result2 = 0;
            end
            4'b0011: {Result2, Result1} = $unsigned(A) * $unsigned(B);
            4'b0100: begin
                Result1 = $unsigned(A) / $unsigned(B);
                Result2 = $unsigned(A) % $unsigned(B);
            end
            4'b0101: begin
                Result1 = A + B;
                Result2 = 0;
            end
            4'b0110: begin
                Result1 = A - B;
                Result2 = 0;
            end
            4'b0111: begin
                Result1 = A & B;
                Result2 = 0;
            end
            4'b1000: begin
                Result1 = A | B;
                Result2 = 0;
            end
            4'b1001: begin
                Result1 = A ^ B;
                Result2 = 0;
            end
            4'b1010: begin
                Result1 = ~(A | B);
                Result2 = 0;
            end
            4'b1011: begin
                Result1 = ($signed(A) < $signed(B)) ? 1 : 0;
                Result2 = 0;
            end
            4'b1100: begin
                Result1 = ($unsigned(A) < $unsigned(B)) ? 1 : 0;
                Result2 = 0;
            end
            default: begin
                Result1 = 0;
                Result2 = 0;
            end
        endcase
    end

    always @(*) begin
        Equal = (A == B);
        if (ALUOp == 4'b1011) begin
            LT = ($signed(A) < $signed(B));
            GE = ($signed(A) >= $signed(B));
        end
        else if (ALUOp == 4'b1100) begin
            LT = ($unsigned(A) < $unsigned(B));
            GE = ($unsigned(A) >= $unsigned(B));
        end
        else begin
            LT = 0;
            GE = 0;
        end
    end
    
endmodule