module next_int(IR, IRS, nxt_int);
    input [2:0] IR;
    input [2:0] IRS;
    output reg [2:0] nxt_int;

// the biggest priority IR and not equal to IRS

    always @(IR or IRS) begin
        if (IR[2] && IR[2] != IRS[2]) begin
            nxt_int = {1'b1, 2'b00};
        end else if (IR[1] && IR[1] != IRS[1]) begin
            nxt_int = {1'b0, 1'b1, 1'b0};
        end else if (IR[0] && IR[0] != IRS[0]) begin
            nxt_int = {1'b0, 1'b0, 1'b1};
        end else begin
            nxt_int = {1'b0, 1'b0, 1'b0};
        end
    end

endmodule