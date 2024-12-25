/*
  EX、MEM段有写CSR，就要暂停PC,IF/ID段，清空ID/EX段
  CSRRSI, CSRRCI, CSRRW, URET, 隐指令
*/
module cpu (rst, clk, GO, LedData, BTN, IRW
, dispAddr, dispColor, rawclk
);
    parameter WIDTH = 32;
    parameter ADDR_WIDTH = 16;
    input rst, clk, GO, rawclk;
    input [3:0] BTN;
    input [ADDR_WIDTH-1:0] dispAddr;
    
    output [WIDTH-1:0] dispColor;
    output [2:0] IRW;
    output [WIDTH-1:0] LedData;

    wire BranchTaken, stall, Continue;

    wire CSR_DATA_HAZZARD, EX_CSRWrite, MEM_CSRWrite;
    assign CSR_DATA_HAZZARD = EX_CSRWrite | MEM_CSRWrite;

    wire PC_en;
    assign PC_en = Continue & !stall & !CSR_DATA_HAZZARD;
    reg signed [WIDTH-1:0] PC_next;
    wire signed [WIDTH-1:0] IF_PC;
    
    register #(.WIDTH(WIDTH)) PC_reg(clk, PC_en, rst, PC_next, IF_PC);

    wire [WIDTH-1:0] IF_IR;
    wire [ADDR_WIDTH-1:0] text_addr;
    assign text_addr = IF_PC[1+ADDR_WIDTH:2];
    rom_text #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ROM(text_addr, IF_IR, rawclk);

    wire [WIDTH-1:0] ID_PC, ID_IR;
    wire IF2ID_en, IF2ID_rst;
    wire WB_INT;
    assign IF2ID_en = Continue & !stall & !CSR_DATA_HAZZARD;
    assign IF2ID_rst = BranchTaken | rst | WB_INT;

    IF2ID #(.WIDTH(WIDTH)) if2id(.clk(clk), .en(IF2ID_en), .rst(IF2ID_rst), 
        .PC_in(IF_PC), .PC_out(ID_PC), .IR_in(IF_IR), .IR_out(ID_IR));

    wire ID_MemToReg, ID_MemWrite, ID_ALU_SRC, ID_RegWrite, ID_uret, ID_ecall, S_type, ID_Beq, ID_Bne, 
        ID_Jalr, ID_JAL, ID_LUI, ID_LBU, ID_Bltu, ID_CSRRSI, ID_CSRRCI, ID_CSRRW;
    wire ID_LB, ID_LH, ID_LHU, ID_BLT, ID_BGE, ID_BGEU, ID_SB, ID_SH, ID_AUIPC;
    wire ID_CSRRC, ID_CSRRS, ID_CSRRWI;
    wire [3:0] ID_ALU_OP;
    wire R1_Used, R2_Used;

    wire [4:0] OP_CODE;
    wire [4:0] Funct;
    wire IR21;
    assign OP_CODE = ID_IR[6:2];
    assign Funct = {ID_IR[30],ID_IR[25],ID_IR[14:12]};
    assign IR21 = ID_IR[21];
    controler #(.WIDTH(WIDTH)) CONTROLER(OP_CODE, Funct, IR21, ID_ALU_OP, 
        ID_MemToReg, ID_MemWrite, ID_ALU_SRC, ID_RegWrite, ID_uret, ID_ecall, S_type, ID_Beq, ID_Bne, 
        ID_Jalr, ID_JAL, ID_LUI, ID_LBU, ID_Bltu, ID_CSRRSI, ID_CSRRCI, ID_CSRRW,
        R1_Used, R2_Used,
        ID_LB, ID_LH, ID_LHU, ID_BLT, ID_BGE, ID_BGEU, ID_SB, ID_SH, ID_AUIPC, 
        ID_CSRRC, ID_CSRRS, ID_CSRRWI);

    wire [2:0] IRQ;
    wire [1:0] IRQ_data [0:2];

    priority_encoder42 btn_irq(.x0(BTN[0]), .x1(BTN[1]), .x2(BTN[2]), .x3(BTN[3]), .y(IRQ_data[0]), .sel(IRQ[0]));

    wire [2:0] IR, IRS, IP, WB_IRS;
    wire IE, WB_IEWriteData, WB_IEWrite, WB_EPCWrite, WB_uret;
    wire WB_CAUSEWrite;
    wire [WIDTH-1:0] EPC, WB_EPCWriteData;
    wire [WIDTH-1:0] CAUSE, WB_CAUSEWriteData;
    reg [2:0] WB_IRSWriteData;
    ir Ir(.clk(clk), .rst(rst), .IRQ(IRQ), .Clr(WB_uret), .ClrInt(WB_IRS), .IR(IR), .IRW(IRW));
    ie Ie(.clk(!clk), .rst(rst), .we(WB_IEWrite), .dataIn(WB_IEWriteData), .IE(IE));
    irs Irs(.clk(!clk), .rst(rst), .we(WB_INT), .dataIn(WB_IRSWriteData), .IRS(IRS)); // WB后有效，中断隐指令 和 uret 写 IRS
    epc Epc(.clk(!clk), .rst(rst), .we(WB_EPCWrite), .dataIn(WB_EPCWriteData), .EPC(EPC));
    cause Cause(.clk(!clk), .rst(rst), .we(WB_CAUSEWrite), .dataIn(WB_CAUSEWriteData), .CAUSE(CAUSE));
    ip Ip(.clk(!clk), .rst(rst), .we(WB_INT), .IRS(WB_IRS), .IP(IP)); // 中断隐指令 和 uret 写 IP
    /*
        有写CSR的时候，保证IF,ID停止，EX,MEM段插入NOP
        WB段下降沿写EPC,IE,IRS,IP
        开中断后，ID后半段读的是正确的，交EX段处理
        如果要写PC，下一个上升沿来时写，清空IF/ID, ID/EX段
        uret 时，开IE，IR，IP对应的位清空，IRS写为下一个中断，写PC，IR可在下一个上升沿写，因为IF/ID段已经清空
        ID决定进入中断隐指令时，不管后续的新中断
    */

    wire [2:0] pri_IR;
    highbit HighBit(.x(IR), .y(pri_IR));

    wire ID_Int_Enter, ID_CSRWrite;
    assign ID_Int_Enter = !CSR_DATA_HAZZARD && (ID_IR != 0) && IE && (pri_IR != 0) && !(IP & pri_IR);
    wire ID_CSR_OP;
    assign ID_CSR_OP = ID_CSRRSI | ID_CSRRCI | ID_CSRRW | ID_CSRRC | ID_CSRRS | ID_CSRRWI;
    assign ID_CSRWrite = ID_CSR_OP | ID_uret | ID_Int_Enter;
    
    reg [2:0] ID_IRS;
    always @(*) begin
        if (ID_Int_Enter) ID_IRS = pri_IR;
        else ID_IRS = IRS;
    end

    wire [11:0] ID_csr;
    assign ID_csr = ID_IR[31:20];
    wire [4:0] ID_zimm;
    assign ID_zimm = ID_IR[19:15];

    reg [WIDTH-1:0] ID_t;
    always @(*) begin
        if (ID_csr == 'h341) ID_t = EPC;
        else if (ID_csr == 'h304) ID_t = {31'b0, IE};
        else if (ID_csr == 'h342) ID_t = CAUSE;
        else ID_t = 0;
    end

    wire [4:0] R1no, R2no;
    assign R1no = ID_ecall ? 'h0A : ID_IR[19:15];
    assign R2no = ID_ecall ? 'h11 : ID_IR[24:20];

    wire [4:0] ID_Wno;
    assign ID_Wno = ID_IR[11:7];

    wire signed [WIDTH-1:0] ID_R1, ID_R2;
    wire [WIDTH-1:0] WB_Din;
    wire WB_RegWrite;
    wire [4:0] WB_Wno;
    regfile RegFile(!clk, R1no, R2no, WB_Wno, WB_Din, WB_RegWrite, ID_R1, ID_R2);

    wire signed [WIDTH-1:0] Imm;
    assign Imm = S_type ? {{20{ID_IR[31]}},ID_IR[31:25],ID_IR[11:7]} : {{20{ID_IR[31]}},ID_IR[31:20]};

    wire signed [WIDTH-1:0] BImm;
    assign BImm = {{20{ID_IR[31]}},ID_IR[7],ID_IR[30:25],ID_IR[11:8],1'b0};

    wire signed [WIDTH-1:0] JalImm;
    assign JalImm = {{12{ID_IR[31]}},ID_IR[19:12],ID_IR[20],ID_IR[30:21],1'b0};

    wire signed [WIDTH-1:0] UImm;
    assign UImm = {ID_IR[31:12],12'b0};

    wire ID_B;
    wire [1:0] Imm_type;
    assign ID_B = ID_Beq | ID_Bne | ID_Bltu | ID_BLT | ID_BGE | ID_BGEU;

    wire ID_U;
    assign ID_U = ID_LUI | ID_AUIPC;

    priority_encoder42 immPri(.x0(1'b1), .x1(ID_B), .x2(ID_JAL), .x3(ID_U), .y(Imm_type), .sel(_));
    wire [WIDTH-1:0] ID_SignImm;
    mux41 #(.DATA_WIDTH(WIDTH)) ImmMUX(.a(Imm), .b(BImm), .c(JalImm), .d(UImm), .sel(Imm_type), .out(ID_SignImm));

    wire flush;
    wire [1:0] R1Forward, R2Forward;

    wire [4:0] EX_WriteRegNo, MEM_WriteRegNo;
    wire EX_MemToReg, MEM_RegWrite, EX_RegWrite;

    data_forwarding data_fwd(.R1_Used(R1_Used), .R1no(R1no), .R2_Used(R2_Used), .R2no(R2no), 
        .EX_RegWrite(EX_RegWrite), .EX_WriteRegNo(EX_WriteRegNo), .MEM_RegWrite(MEM_RegWrite), .MEM_WriteRegNo(MEM_WriteRegNo),
        .EX_MemRead(EX_MemToReg), .BranchTaken(BranchTaken), .R1Forward(R1Forward), .R2Forward(R2Forward), .stall(stall), .flush(flush));

    wire [WIDTH-1:0] EX_PC, EX_IR, EX_R1, EX_R2, EX_SignImm;
    wire EX_MemWrite, EX_LBU, EX_Beq, EX_Bne, EX_Bltu, EX_JAL, EX_Jalr, EX_LUI;
    wire EX_LB, EX_LH, EX_LHU, EX_Blt, EX_Bge, EX_Bgeu, EX_SB, EX_SH, EX_AUIPC;
    wire [3:0] EX_ALU_OP;
    wire EX_ALU_SRC, EX_ecall;
    wire [1:0] FwdA, FwdB;

    wire id2ex_rst;
    assign id2ex_rst = flush | rst | CSR_DATA_HAZZARD | WB_INT;

    wire [11:0] EX_csr;
    wire [4:0] EX_zimm;
    wire [WIDTH-1:0] EX_t;
    wire EX_uret, EX_Int_Enter, EX_CSRRCI, EX_CSRRSI, EX_CSRRW;
    wire EX_CSRRC, EX_CSRRS, EX_CSRRWI;
    wire [2:0] EX_IRS;

    ID2EX #(.WIDTH(WIDTH)) id2ex(.clk(clk), .en(Continue), .rst(id2ex_rst), 
        .RegWrite_in(ID_RegWrite), .RegWrite_out(EX_RegWrite), .WriteRegNo_in(ID_Wno), .WriteRegNo_out(EX_WriteRegNo),
        .MemToReg_in(ID_MemToReg), .MemToReg_out(EX_MemToReg), .MemWrite_in(ID_MemWrite), .MemWrite_out(EX_MemWrite),
        .LBU_in(ID_LBU), .LBU_out(EX_LBU), .ALU_OP_in(ID_ALU_OP), .ALU_OP_out(EX_ALU_OP), 
        .ALU_SrcB_in(ID_ALU_SRC), .ALU_SrcB_out(EX_ALU_SRC),
        .BEQ_in(ID_Beq), .BEQ_out(EX_Beq), .BNE_in(ID_Bne), .BNE_out(EX_Bne), .BLTU_in(ID_Bltu), .BLTU_out(EX_Bltu),
        .JAL_in(ID_JAL), .JAL_out(EX_JAL), .JALR_in(ID_Jalr), .JALR_out(EX_Jalr), .LUI_in(ID_LUI), .LUI_out(EX_LUI),
        .R1Forward_in(R1Forward), .R1Forward_out(FwdA), .R2Forward_in(R2Forward), .R2Forward_out(FwdB),
        .PC_in(ID_PC), .PC_out(EX_PC), .IR_in(ID_IR), .IR_out(EX_IR),
        .R1_in(ID_R1), .R1_out(EX_R1), .R2_in(ID_R2), .R2_out(EX_R2), 
        .SignImm_in(ID_SignImm), .SignImm_out(EX_SignImm), .ecall_in(ID_ecall), .ecall_out(EX_ecall),
        .CSRRCI_in(ID_CSRRCI), .CSRRCI_out(EX_CSRRCI), .CSRRSI_in(ID_CSRRSI), .CSRRSI_out(EX_CSRRSI), 
        .CSRRW_in(ID_CSRRW), .CSRRW_out(EX_CSRRW), .uret_in(ID_uret), .uret_out(EX_uret), 
        .Int_Enter_in(ID_Int_Enter), .Int_Enter_out(EX_Int_Enter), .CSRWrite_in(ID_CSRWrite), .CSRWrite_out(EX_CSRWrite),
        .csr_in(ID_csr), .csr_out(EX_csr), .zimm_in(ID_zimm), .zimm_out(EX_zimm), .t_in(ID_t), .t_out(EX_t), 
        .IRS_in(ID_IRS), .IRS_out(EX_IRS),
        .LB_in(ID_LB), .LB_out(EX_LB), .LH_in(ID_LH), .LH_out(EX_LH), .LHU_in(ID_LHU), .LHU_out(EX_LHU),
        .BLT_in(ID_BLT), .BLT_out(EX_Blt), .BGE_in(ID_BGE), .BGE_out(EX_Bge), .BGEU_in(ID_BGEU), .BGEU_out(EX_Bgeu),
        .SB_in(ID_SB), .SB_out(EX_SB), .SH_in(ID_SH), .SH_out(EX_SH),
        .AUIPC_in(ID_AUIPC), .AUIPC_out(EX_AUIPC), 
        .CSRRC_in(ID_CSRRC), .CSRRC_out(EX_CSRRC), .CSRRS_in(ID_CSRRS), .CSRRS_out(EX_CSRRS), 
        .CSRRWI_in(ID_CSRRWI), .CSRRWI_out(EX_CSRRWI));

    wire [WIDTH-1:0] True_R1, True_R2, MEM_ALUout;
    mux41 #(.DATA_WIDTH(WIDTH)) R1MUX(.a(EX_R1), .b(WB_Din), .c(MEM_ALUout), .d(0), .sel(FwdA), .out(True_R1));
    mux41 #(.DATA_WIDTH(WIDTH)) R2MUX(.a(EX_R2), .b(WB_Din), .c(MEM_ALUout), .d(0), .sel(FwdB), .out(True_R2));

    wire EX_IEWrite, EX_EPCWrite;
    wire EX_CAUSEWrite;
    reg EX_IEWriteData;
    reg [WIDTH-1:0] EX_EPCWriteData;
    reg [WIDTH-1:0] EX_CAUSEWriteData;

    reg [WIDTH-1:0] csrdatain;
    always @(*) begin
        if (EX_CSRRCI) csrdatain = EX_t & ~{27'b0,EX_zimm};
        else if (EX_CSRRSI) csrdatain = EX_t | {27'b0,EX_zimm};
        else if (EX_CSRRW) csrdatain = True_R1;
        else if (EX_CSRRC) csrdatain = EX_t & ~True_R1;
        else if (EX_CSRRS) csrdatain = EX_t | True_R1;
        else if (EX_CSRRWI) csrdatain = {27'b0,EX_zimm};
        else csrdatain = 0;
    end

    wire EX_CSR_OP;
    assign EX_CSR_OP = EX_CSRRCI | EX_CSRRSI | EX_CSRRW | EX_CSRRC | EX_CSRRS | EX_CSRRWI;
    assign EX_IEWrite = (EX_CSR_OP) && EX_csr == 'h304 || EX_uret || EX_Int_Enter;
    always @(*) begin
        if (EX_Int_Enter) EX_IEWriteData = 0;
        else if (EX_CSR_OP) EX_IEWriteData = EX_csr == 'h304 ? csrdatain[0] : 1;
        else if (EX_uret) EX_IEWriteData = 1;
        else EX_IEWriteData = 1;
    end

    assign EX_EPCWrite = (EX_CSR_OP) && EX_csr == 'h341 || EX_Int_Enter;
    always @(*) begin
        if (EX_Int_Enter) EX_EPCWriteData = EX_PC;
        else if (EX_CSR_OP) EX_EPCWriteData = EX_csr == 'h341 ? csrdatain : 0;
        else EX_EPCWriteData = 0;
    end

    assign EX_CAUSEWrite = (EX_CSR_OP) && EX_csr == 'h342 || EX_Int_Enter;
    always @(*) begin
        if (EX_Int_Enter) begin
            if (EX_IRS == 3'b001) EX_CAUSEWriteData = {30'b0, IRQ_data[0]};
            else if (EX_IRS == 3'b010) EX_CAUSEWriteData = 0; //TODO
            else EX_CAUSEWriteData = 0; //TODO
        end
        else if (EX_CSR_OP) EX_CAUSEWriteData = EX_csr == 'h342 ? csrdatain : 0;
        else EX_CAUSEWriteData = 0;
    end

    wire [WIDTH-1:0] EX_a0, EX_a7;
    assign EX_a0 = EX_ecall ? True_R1 : 0;
    assign EX_a7 = EX_ecall ? True_R2 : 0;

    wire [WIDTH-1:0] X, Y;
    assign X = True_R1;
    assign Y = EX_ALU_SRC ? EX_SignImm : True_R2;

    wire [WIDTH-1:0] ALUout, ALUout2;
    wire Equal, LT, GE;

    alu #(.WIDTH(WIDTH)) ALU(X, Y, EX_ALU_OP, ALUout, ALUout2, Equal, LT, GE);

    wire EX_J, EX_B;
    assign EX_J = EX_JAL | EX_Jalr;
    assign EX_B = (EX_Beq & Equal) | (EX_Bne & ~Equal) | ((EX_Bltu | EX_Blt) & LT) | ((EX_Bgeu | EX_Bge) & GE);
    assign BranchTaken = EX_J | EX_B;

    reg [WIDTH-1:0] EX_ALUResult;
    always @(*) begin
        if (EX_LUI) EX_ALUResult = EX_SignImm;
        else if (EX_AUIPC) EX_ALUResult = EX_PC + EX_SignImm;
        else if (EX_J) EX_ALUResult = EX_PC + 4;
        else if (EX_CSR_OP) EX_ALUResult = EX_t;
        else EX_ALUResult = ALUout;
    end

    always @(EX_Jalr, ALUout, BranchTaken, IF_PC, EX_SignImm, EX_PC, WB_uret, WB_Int_Enter, WB_IRS, EPC) begin
         if (WB_Int_Enter) begin
            case (WB_IRS) 
                3'b001: PC_next = 'h00000030;
                3'b010: PC_next = 'h00003170;
                3'b100: PC_next = 'h00003234;
                default: PC_next = IF_PC + 4;
            endcase
        end
        else if (EX_Jalr) PC_next = ALUout & 'hFFFFFFFE;
        else if (BranchTaken) PC_next = EX_SignImm + EX_PC;
        else if (WB_uret) PC_next = EPC;
        else PC_next = IF_PC + 4;
    end

    wire [WIDTH-1:0] MEM_WriteData;
    wire MEM_LBU, MEM_MemToReg, MEM_MemWrite, MEM_ecall;
    wire MEM_LB, MEM_LH, MEM_LHU, MEM_SB, MEM_SH;
    wire [WIDTH-1:0] MEM_PC, MEM_IR, MEM_a0, MEM_a7;
    wire MEM_uret, MEM_Int_Enter, MEM_IEWrite, MEM_EPCWrite, MEM_IEWriteData;
    wire [WIDTH-1:0] MEM_EPCWriteData;
    wire MEM_CAUSEWrite;
    wire [WIDTH-1:0] MEM_CAUSEWriteData;
    wire [2:0] MEM_IRS;

    EX2MEM #(.WIDTH(WIDTH)) ex2mem(.clk(clk), .en(Continue), .rst(rst), 
        .RegWrite_in(EX_RegWrite), .RegWrite_out(MEM_RegWrite), .WriteRegNo_in(EX_WriteRegNo), .WriteRegNo_out(MEM_WriteRegNo),
        .MemToReg_in(EX_MemToReg), .MemToReg_out(MEM_MemToReg), .MemWrite_in(EX_MemWrite), .MemWrite_out(MEM_MemWrite),
        .LBU_in(EX_LBU), .LBU_out(MEM_LBU), .PC_in(EX_PC), .PC_out(MEM_PC), .IR_in(EX_IR), .IR_out(MEM_IR),
        .WriteData_in(True_R2), .WriteData_out(MEM_WriteData), .Result_in(EX_ALUResult), .Result_out(MEM_ALUout),
        .ecall_in(EX_ecall), .ecall_out(MEM_ecall), .a0_in(EX_a0), .a0_out(MEM_a0), .a7_in(EX_a7), .a7_out(MEM_a7), 
        .uret_in(EX_uret), .uret_out(MEM_uret), .Int_Enter_in(EX_Int_Enter), .Int_Enter_out(MEM_Int_Enter), 
        .CSRWrite_in(EX_CSRWrite), .CSRWrite_out(MEM_CSRWrite),
        .IEWrite_in(EX_IEWrite), .IEWrite_out(MEM_IEWrite), .EPCWrite_in(EX_EPCWrite), .EPCWrite_out(MEM_EPCWrite),
        .IEWriteData_in(EX_IEWriteData), .IEWriteData_out(MEM_IEWriteData), 
        .EPCWriteData_in(EX_EPCWriteData), .EPCWriteData_out(MEM_EPCWriteData), 
        .IRS_in(EX_IRS), .IRS_out(MEM_IRS), 
        .LB_in(EX_LB), .LB_out(MEM_LB), .LH_in(EX_LH), .LH_out(MEM_LH), .LHU_in(EX_LHU), .LHU_out(MEM_LHU),
        .SB_in(EX_SB), .SB_out(MEM_SB), .SH_in(EX_SH), .SH_out(MEM_SH), 
        .CAUSEWrite_in(EX_CAUSEWrite), .CAUSEWrite_out(MEM_CAUSEWrite), 
        .CAUSEWriteData_in(EX_CAUSEWriteData), .CAUSEWriteData_out(MEM_CAUSEWriteData));

    wire [WIDTH-1:0] MemData;
    wire [ADDR_WIDTH-1:0] MemData_addr;
    assign MemData_addr = MEM_ALUout[1+ADDR_WIDTH:2];
    reg [3:0] ram_sel;

    always @(*) begin
        if (MEM_SB) begin
            if (MEM_ALUout[1:0] == 2'b00) ram_sel = 4'b0001;
            else if (MEM_ALUout[1:0] == 2'b01) ram_sel = 4'b0010;
            else if (MEM_ALUout[1:0] == 2'b10) ram_sel = 4'b0100;
            else ram_sel = 4'b1000;
        end
        else if (MEM_SH) begin
            if (MEM_ALUout[1]) ram_sel = 4'b1100;
            else ram_sel = 4'b0011;
        end
        else ram_sel = 4'b1111;
    end
    
    

    ram #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) RAM(.rst(rst), .we(MEM_MemWrite), .sel(ram_sel), .addr(MemData_addr), .d(MEM_WriteData), .q(MemData)
    , .dispAddr(dispAddr), .dispColor(dispColor), .rawclk(rawclk)
    );
//    RegRam #(.DATA_WIDTH(WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) RAM(.rst(rst), .we(MEM_MemWrite), .sel(ram_sel), .addr(MemData_addr), .d(MEM_WriteData), .q(MemData)
//    , .dispAddr(dispAddr), .dispColor(dispColor), .clk(clk)
//    );
    
    

    wire [7:0] LoadByte;
    wire [7:0] MemDataByte0, MemDataByte1, MemDataByte2, MemDataByte3;
    assign MemDataByte0 = MemData[7:0];
    assign MemDataByte1 = MemData[15:8];
    assign MemDataByte2 = MemData[23:16];
    assign MemDataByte3 = MemData[31:24];
    wire [1:0] ByteIndex;
    assign ByteIndex = MEM_ALUout[1:0];
    mux41 #(.DATA_WIDTH(8)) ByteMUX(.a(MemDataByte0), .b(MemDataByte1), .c(MemDataByte2), .d(MemDataByte3), .sel(ByteIndex), .out(LoadByte));
    wire [15:0] LoadHalf;
    assign LoadHalf = MEM_ALUout[1] ? {MemData[31:16]} : {MemData[15:0]};

    reg [WIDTH-1:0] MEM_MemToRegData;
    always @(*) begin
        if (MEM_LBU) MEM_MemToRegData = {24'b0,LoadByte};
        else if (MEM_LB) MEM_MemToRegData = {{24{LoadByte[7]}},LoadByte};
        else if (MEM_LHU) MEM_MemToRegData = {16'b0,LoadHalf};
        else if (MEM_LH) MEM_MemToRegData = {{16{LoadHalf[15]}},LoadHalf};
        else MEM_MemToRegData = MemData;
    end
    wire [WIDTH-1:0] WB_MemData, WB_ALUResult;
    wire WB_MemToReg;
    wire [WIDTH-1:0] WB_PC, WB_IR;
    wire [WIDTH-1:0] a0, a7;

    MEM2WB #(.WIDTH(WIDTH)) mem2wb(.clk(clk), .en(Continue), .rst(rst), 
        .RegWrite_in(MEM_RegWrite), .RegWrite_out(WB_RegWrite), .WriteRegNo_in(MEM_WriteRegNo), .WriteRegNo_out(WB_Wno),
        .MemToReg_in(MEM_MemToReg), .MemToReg_out(WB_MemToReg), .PC_in(MEM_PC), .PC_out(WB_PC), .IR_in(MEM_IR), .IR_out(WB_IR),
        .MemData_in(MEM_MemToRegData), .MemData_out(WB_MemData), .ALU_Result_in(MEM_ALUout), .ALU_Result_out(WB_ALUResult),
        .ecall_in(MEM_ecall), .ecall_out(ecall), .a0_in(MEM_a0), .a0_out(a0), .a7_in(MEM_a7), .a7_out(a7), 
        .uret_in(MEM_uret), .uret_out(WB_uret), .Int_Enter_in(MEM_Int_Enter), .Int_Enter_out(WB_Int_Enter), 
        .CSRWrite_in(MEM_CSRWrite), .CSRWrite_out(WB_CSRWrite),
        .IEWrite_in(MEM_IEWrite), .IEWrite_out(WB_IEWrite), .EPCWrite_in(MEM_EPCWrite), .EPCWrite_out(WB_EPCWrite), 
        .IEWriteData_in(MEM_IEWriteData), .IEWriteData_out(WB_IEWriteData),
        .EPCWriteData_in(MEM_EPCWriteData), .EPCWriteData_out(WB_EPCWriteData), 
        .IRS_in(MEM_IRS), .IRS_out(WB_IRS), 
        .CAUSEWrite_in(MEM_CAUSEWrite), .CAUSEWrite_out(WB_CAUSEWrite),
        .CAUSEWriteData_in(MEM_CAUSEWriteData), .CAUSEWriteData_out(WB_CAUSEWriteData));

    assign WB_Din = WB_MemToReg ? WB_MemData : WB_ALUResult;

    assign WB_INT = WB_Int_Enter | WB_uret;
//  uret: 开中断, 清理IR, 写PC,
    wire [2:0] next_IRS;
    next_int Next_Int(.IR(IR), .IRS(WB_IRS), .nxt_int(next_IRS));

    always @(*) begin
        if (WB_uret) WB_IRSWriteData = next_IRS;
        else WB_IRSWriteData = WB_IRS;
    end

    wire halt, LedEn;
    assign halt = ecall & (a7 != 'h22);
    assign LedEn = ecall & (a7 == 'h22);

//    register #(.WIDTH(WIDTH)) LedDataReg(clk, LedEn, rst, a0, LedData);
     wire [WIDTH-1:0] MockLedData;
     assign MockLedData = ((EX_PC)<<16) | (a0 & 32'h0000ffff);
     register #(.WIDTH(WIDTH)) LedDataReg(clk, 1'b1, rst, MockLedData, LedData);

    wire GoRegRst, GoRegData;
    assign GoRegRst = !ecall | rst;
    assign GoRegData = GO && halt;

    register #(.WIDTH(1)) GoReg(clk, 1'b1, GoRegRst, GoRegData, GoRegOut);

    assign Continue = GoRegOut | !halt;

endmodule