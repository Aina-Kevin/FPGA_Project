module MEMORY_DATA_REGISTER (
    input  wire [7:0] IN_MDR,
    input  wire       FSM_Signal,       
    input  wire       load_MDR,    
    input  wire       reset_MDR,   
    output reg  [7:0] OUT_MDR
);
    always @(negedge FSM_Signal) begin
    //    OUT_MDR = OUT_MDR;
        if (reset_MDR) begin
            OUT_MDR = 8'b00000000;
        end else if (load_MDR) begin
            OUT_MDR = IN_MDR; 
        end
    end
endmodule
