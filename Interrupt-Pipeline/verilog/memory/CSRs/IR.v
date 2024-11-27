module ir(clk, rst, IRQ, Clr, ClrInt, IR, IRW);
    input clk, Clr, rst;
    input [2:0] IRQ, ClrInt;
    wire [2:0] IntR;
    wire [2:0] IntD;
    output [2:0] IR;
    output [2:0] IRW;

    assign IntD[0] = (IntR[0] | IR[0]) & ~(ClrInt[0] & Clr);
    assign IntD[1] = (IntR[1] | IR[1]) & ~(ClrInt[1] & Clr);
    assign IntD[2] = (IntR[2] | IR[2]) & ~(ClrInt[2] & Clr);

    d_flip_flop Int_input0(clk, rst, IntD[0], IR[0]);
    d_flip_flop Int_input1(clk, rst, IntD[1], IR[1]);
    d_flip_flop Int_input2(clk, rst, IntD[2], IR[2]);

    d_flip_flop IntR_input0(IRQ[0], IR[0] | rst, 1'b1, IntR[0]);
    d_flip_flop IntR_input1(IRQ[1], IR[1] | rst, 1'b1, IntR[1]);
    d_flip_flop IntR_input2(IRQ[2], IR[2] | rst, 1'b1, IntR[2]);

    assign IRW = IR | IntR;

endmodule