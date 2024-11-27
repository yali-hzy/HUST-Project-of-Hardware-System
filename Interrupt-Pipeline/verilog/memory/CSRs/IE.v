module ie(clk, rst, we, dataIn, IE);
    input clk, we, dataIn, rst;
    output reg IE;

    initial begin
        IE = 1'b1;
    end

    always @(posedge clk) begin
        if (rst) IE <= 1'b1;
        else if (we) IE <= dataIn;
    end

endmodule