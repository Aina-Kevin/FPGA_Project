
module PROGRAMM_COUNTER (
    input wire CLK,           
    input wire reset_PC,     
    input wire load_PC,      
    input wire inc_PC,        
    input wire [15:0] IN_PC, 
    output wire [15:0] OUT_PC     
);

    reg [15:0] PC = 16'b0; 

    assign OUT_PC = PC;

    always @(posedge CLK) begin
        if (reset_PC) begin
            PC <= 16'b0;
        end else if (load_PC) begin
            PC <= IN_PC;
        end else if (inc_PC) begin
            PC <= PC + 16'b1;
        end
    end

endmodule
