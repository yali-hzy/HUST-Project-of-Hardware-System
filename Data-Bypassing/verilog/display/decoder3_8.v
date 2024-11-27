module decoder3_8(num, sel);
input [2: 0] num;
output [7:0] sel;
wire NotIN[2:0];
    
    not
        un0(NotIN[0],num[0]),
        un1(NotIN[1],num[1]),
        un2(NotIN[2],num[2]);

    or
        uo0(sel[0],num[2],num[1],num[0]),
        uo1(sel[1],num[2],num[1],NotIN[0]),
        uo2(sel[2],num[2],NotIN[1],num[0]),
        uo3(sel[3],num[2],NotIN[1],NotIN[0]),
        uo4(sel[4],NotIN[2],num[1],num[0]),
        uo5(sel[5],NotIN[2],num[1],NotIN[0]),
        uo6(sel[6],NotIN[2],NotIN[1],num[0]),
        uo7(sel[7],NotIN[2],NotIN[1],NotIN[0]);
endmodule
