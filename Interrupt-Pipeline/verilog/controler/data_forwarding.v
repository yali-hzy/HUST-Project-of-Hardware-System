module data_forwarding(R1_Used, R1no, R2_Used, R2no, 
    EX_RegWrite, EX_WriteRegNo, MEM_RegWrite, MEM_WriteRegNo,
    EX_MemRead, BranchTaken, R1Forward, R2Forward, stall, flush);

    input R1_Used, R2_Used, EX_RegWrite, MEM_RegWrite, EX_MemRead, BranchTaken;
    input [4:0] R1no, R2no, EX_WriteRegNo, MEM_WriteRegNo;
    output [1:0] R1Forward, R2Forward;
    output stall, flush;

    wire LoadUse;

    assign LoadUse = EX_MemRead & ((R1_Used & (R1no == EX_WriteRegNo) && (R1no != 0)) | (R2_Used & (R2no == EX_WriteRegNo) && (R2no != 0)));

    wire [1:0] R1_USED, R2_USED;

    assign R1_USED = (R1no != 0 && R1_Used) ? 2'b11 : 2'b00;
    assign R2_USED = (R2no != 0 && R2_Used) ? 2'b11 : 2'b00;
    
    wire [1:0] R1_Pri_out, R2_Pri_out;

    priority_encoder42 R1_Pri(1'b1, MEM_RegWrite & (MEM_WriteRegNo == R1no), EX_RegWrite & (EX_WriteRegNo == R1no), 1'b0, R1_Pri_out, _);
    priority_encoder42 R2_Pri(1'b1, MEM_RegWrite & (MEM_WriteRegNo == R2no), EX_RegWrite & (EX_WriteRegNo == R2no), 1'b0, R2_Pri_out, _);

    assign R1Forward = R1_USED & R1_Pri_out;
    assign R2Forward = R2_USED & R2_Pri_out;

    assign stall = LoadUse;
    assign flush = BranchTaken | LoadUse;
    
endmodule