module REGISTER_Y (
    input  wire [7:0] IN_Y,
    input  wire       load_Y,       
    input  wire       FSM_Signal,    
    input  wire       reset_Y,   
    output reg  [7:0] OUT_Y
);
    always @(negedge FSM_Signal) begin
       // OUT_Y = OUT_Y;
        if (reset_Y) begin
            OUT_Y = 8'b00000000;
        end else if (FSM_Signal) begin
            OUT_Y = IN_Y; 
        end
    end
endmodule