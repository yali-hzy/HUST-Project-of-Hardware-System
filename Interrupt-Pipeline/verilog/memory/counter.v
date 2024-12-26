module counter(clk, out);
    parameter WIDTH = 3;
    input clk;                    
    output [WIDTH-1:0] out;
    reg [WIDTH-1:0] tmp_out = 0;             
    
    
    
    always @(posedge clk)  begin  
        tmp_out <= tmp_out + 1;                        
    end                
    assign out = tmp_out;           
endmodule
