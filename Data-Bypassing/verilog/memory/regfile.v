module regfile (
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] data_in,
    input we,
    output [31:0] data_out1,
    output [31:0] data_out2
);

    reg [31:0] regfile[31:0];

    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (we && (rd != 0)) regfile[rd] <= data_in;
    end

    // always @(*) begin
    //     regfile[0] = 0;
    // end

    assign data_out1 = regfile[rs1];
    assign data_out2 = regfile[rs2];

endmodule