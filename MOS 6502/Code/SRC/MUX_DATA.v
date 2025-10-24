module MUX_DATA (
    input  wire [7:0] OUT_A_MUX,
    input  wire [7:0] OUT_RESULT_ALU_MUX,
    input  wire [7:0] OUT_MDR_MUX,
    input  wire [7:0] OUT_IMM_MUX,
    input  wire [7:0] OUT_Y_MUX,
    input  wire [7:0] OUT_X_MUX,
    input  wire [2:0] SELECT_DATA,     
    output reg  [7:0] OUT_DATA_BUS
);

    always @(*) begin
        case (SELECT_DATA)
            3'd0: OUT_DATA_BUS = OUT_A_MUX;
            3'd1: OUT_DATA_BUS = OUT_RESULT_ALU_MUX;
            3'd2: OUT_DATA_BUS = OUT_MDR_MUX;
            3'd3: OUT_DATA_BUS = OUT_IMM_MUX;
            3'd4: OUT_DATA_BUS = OUT_Y_MUX;
            3'd5: OUT_DATA_BUS = OUT_X_MUX;
            default: OUT_DATA_BUS = 8'd0; 
        endcase
    end

endmodule
