module decoder2_4(en, num, a, b, c, d);
    input en;
    input [1:0] num;
    output a, b, c, d;
    wire [1:0] num;
    wire en;
    wire a, b, c, d;
    assign a = en & ~num[1] & ~num[0];
    assign b = en & ~num[1] & num[0];
    assign c = en & num[1] & ~num[0];
    assign d = en & num[1] & num[0];
endmodule