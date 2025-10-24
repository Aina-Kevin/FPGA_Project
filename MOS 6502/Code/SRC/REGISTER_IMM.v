module REGISTER_IMM (
    input  wire [7:0] IN_IMM,
    input  wire       FSM_Signal,       
    input  wire       load_IMM,    
    input  wire       reset_IMM,   
    output reg  [7:0] OUT_IMM
);
    always @(posedge FSM_Signal) begin
   //     OUT_IMM = OUT_IMM;
        if (reset_IMM) begin
            OUT_IMM = 8'b00000000;
        end else if (load_IMM) begin
            OUT_IMM = IN_IMM; 
        end
    end
endmodule
