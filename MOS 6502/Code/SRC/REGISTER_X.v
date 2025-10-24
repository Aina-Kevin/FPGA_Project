module REGISTER_X (
    input  wire [7:0] IN_X,
    input  wire       load_X,       
    input  wire       FSM_Signal,    
    input  wire       reset_X,   
    output reg  [7:0] OUT_X
);
   always @(negedge FSM_Signal) begin
   //     OUT_X = OUT_X;
        if (reset_X) begin
            OUT_X = 8'b00000000;
        end else if (FSM_Signal) begin
            OUT_X = IN_X; 
        end
    end
endmodule