module REGISTER_A (
    input  wire [7:0] IN_A,
    input  wire       FSM_Signal,       
    input  wire       load_A,    
    input  wire       reset_A,   
    output reg  [7:0] OUT_A
);
    always @(posedge FSM_Signal) begin
     //   OUT_A = OUT_A;
        if (reset_A) begin
            OUT_A = 8'b00000000;
        end else if (load_A) begin
            OUT_A = IN_A; 
        end
    end
endmodule
