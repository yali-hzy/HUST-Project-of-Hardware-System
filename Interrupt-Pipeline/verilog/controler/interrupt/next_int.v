module next_int(IR, IRS, nxt_int);
    input [2:0] IR;
    input [2:0] IRS;
    output reg [2:0] nxt_int;

// the biggest priority IR and not equal to IRS

    always @(IR or IRS) begin
        if (IR[2] && IR[2] != IRS[2]) begin
            nxt_int = 3'b100;
        end else if (IR[1] && IR[1] != IRS[1]) begin
            nxt_int = 3'b010;
        end else if (IR[0] && IR[0] != IRS[0]) begin
            nxt_int = 3'b001;
        end else begin
            nxt_int = 3'b000;
        end
    end

endmodule