module INSTRUCTION_REGISTER (
    input  wire [7:0] IN_IR,
    input  wire       FSM_Signal,       
    input  wire       load_IR,    
    input  wire       reset_IR,   
    output reg  [7:0] OUT_IR
);
    always @(posedge FSM_Signal) begin
        //OUT_IR = OUT_IR;
        if (reset_IR) begin
            OUT_IR = 8'b00000000;
        end else if (load_IR ) begin
            OUT_IR = IN_IR; 
        end
    end
endmodule


