module MEMORY_ADRESS_REGISTER (
    input wire        FSM_Signal,         
    input wire        reset_MAR,    
    input wire        load_MARH,    
    input wire        load_MARL,    
    input wire [7:0]  IN_HIGH,      
    input wire [7:0]  IN_LOW,
    output reg [15:0] OUT_MAR
);

always @(posedge FSM_Signal) begin
   // OUT_MAR = OUT_MAR; 
    
    if (reset_MAR) begin
        OUT_MAR = 16'b0;
    end else begin
        if (load_MARH)
            OUT_MAR[15:8] = IN_HIGH;
        if (load_MARL)
            OUT_MAR[7:0] = IN_LOW;
    end
end

endmodule
