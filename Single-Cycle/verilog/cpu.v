module cpu (rst, clk, GO, LedData);
    parameter WIDTH = 32;
    input rst, clk, GO;
    output [WIDTH-1:0] LedData;

    wire PC_en;
    assign PC_en = Continue;
    reg signed [WIDTH-1:0] PC_next;
    wire signed [WIDTH-1:0] PC;
    
    register #(.WIDTH(WIDTH)) PC_reg(clk, PC_en, rst, PC_next, PC);

    wire [WIDTH-1:0] IR;
    wire [9:0] text_addr;
    assign text_addr = PC[11:2];
    rom_text #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(10)) ROM(text_addr, IR);

    wire ALU_SRC, MemToReg, MemWrite, RegWrite, uret, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, STI, CLI, R1_Used, R2_Used;
    wire [3:0] ALU_OP;
    
    wire [4:0] OP_CODE;
    wire [4:0] Funct;
    wire IR21;
    assign OP_CODE = IR[6:2];
    assign Funct = {IR[30],IR[25],IR[14:12]};
    assign IR21 = IR[21];
    controler #(.WIDTH(WIDTH)) CONTROLER(OP_CODE, Funct, IR21, ALU_OP, 
        MemToReg, MemWrite, ALU_SRC, RegWrite, uret, ecall, S_type, Beq, Bne, Jalr, JAL, LUI, LBU, Bltu, STI, CLI,
        R1_Used, R2_Used);
    
    wire [4:0] R1no, R2no, Wno;
    assign R1no = ecall ? 'h11 : IR[19:15];
    assign R2no = ecall ? 'h0A : IR[24:20];
    assign Wno = IR[11:7];

    wire signed [WIDTH-1:0] R1, R2;
    reg [WIDTH-1:0] Din;
    regfile RegFile(clk, R1no, R2no, Wno, Din, RegWrite, R1, R2);
    wire signed [WIDTH-1:0] a0, a7;
    assign a7 = ecall ? R1 : 0;
    assign a0 = ecall ? R2 : 0;

    wire signed [WIDTH-1:0] Imm;
    assign Imm = S_type ? {{20{IR[31]}},IR[31:25],IR[11:7]} : {{20{IR[31]}},IR[31:20]};

    wire signed [WIDTH-1:0] BImm;
    assign BImm = {{20{IR[31]}},IR[7],IR[30:25],IR[11:8],1'b0};

    wire signed [WIDTH-1:0] JalImm;
    assign JalImm = {{12{IR[31]}},IR[19:12],IR[20],IR[30:21],1'b0};

    wire [WIDTH-1:0] X, Y;
    assign X = R1;
    assign Y = ALU_SRC ? Imm : R2;

    wire [WIDTH-1:0] ALUout, ALUout2;
    wire Equal, LT, GE;

    alu #(.WIDTH(WIDTH)) ALU(X, Y, ALU_OP, ALUout, ALUout2, Equal, LT, GE);

    wire B, J;

    assign J = JAL | Jalr;
    assign B = (Beq & Equal) | (Bne & ~Equal) | (Bltu & LT);

    wire [WIDTH-1:0] MemData;
    wire [9:0] MemAddr;
    assign MemAddr = ALUout[11:2];
    ram #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(10)) RAM(rst, clk, MemWrite, MemAddr, R2, MemData);

    wire [7:0] LoadByte;
    wire [7:0] DataByte0, DataByte1, DataByte2, DataByte3;
    wire [1:0] ByteNo;
    assign ByteNo = ALUout[1:0];
    assign DataByte0 = MemData[7:0];
    assign DataByte1 = MemData[15:8];
    assign DataByte2 = MemData[23:16];
    assign DataByte3 = MemData[31:24];
    mux41 #(.DATA_WIDTH(8)) ByteMUX(DataByte0, DataByte1, DataByte2, DataByte3, ByteNo, LoadByte);

    reg [WIDTH-1:0] MemToRegData;
    always @(MemData, LBU, LoadByte) begin
        if (LBU) MemToRegData = {24'b0, LoadByte};
        else MemToRegData = MemData;
    end

    always @(J, LUI, MemToReg, PC, IR, MemToRegData, ALUout) begin
        if (J) Din = PC + 4;
        else if (LUI) Din = {IR[31:12],12'b0};
        else if (MemToReg) Din = MemToRegData;
        else Din = ALUout;
    end

    always @(PC, JAL, Jalr, B, JalImm, BImm, Imm, PC, R1) begin
        if (JAL) PC_next = PC + JalImm;
        else if (Jalr) PC_next = (R1 + Imm) & 32'hfffffffe;
        else if (B) PC_next = PC + BImm;
        else PC_next = PC + 4;
    end

    wire halt, LedEn;
    assign halt = ecall & (a7 != 'h22);
    assign LedEn = ecall & (a7 == 'h22);

    register #(.WIDTH(WIDTH)) LedDataReg(clk, LedEn, rst, a0, LedData);

    wire GoRegRst, GoRegData;
    assign GoRegRst = !ecall | rst;
    assign GoRegData = GO && halt;

    register #(.WIDTH(1)) GoReg(clk, 1'b1, GoRegRst, GoRegData, GoRegOut);

    assign Continue = GoRegOut | !halt;

endmodule