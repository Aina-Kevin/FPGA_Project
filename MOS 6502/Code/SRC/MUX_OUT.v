module MUX_OUT (
    input  wire [7:0] OUT_A_to_FPGA,
    input  wire [7:0] OUT_MDR_to_FPGA,
    input  wire [7:0] OUT_IMM_to_FPGA,
    input  wire [7:0] OUT_Y_to_FPGA,
    input  wire [7:0] OUT_X_to_FPGA, 
    input  wire [2:0] SELECT_OUT,     
    output reg  [7:0] OUT_DATA_BUS_to_FPGA
);

    always @(*) begin
        case (SELECT_OUT)
            3'd0: OUT_DATA_BUS_to_FPGA = OUT_A_to_FPGA;
            3'd1: OUT_DATA_BUS_to_FPGA = OUT_MDR_to_FPGA;
            3'd2: OUT_DATA_BUS_to_FPGA = OUT_IMM_to_FPGA;
            3'd3: OUT_DATA_BUS_to_FPGA = OUT_Y_to_FPGA;
            3'd4: OUT_DATA_BUS_to_FPGA = OUT_X_to_FPGA;
            default: OUT_DATA_BUS_to_FPGA = 8'd0; 
        endcase
    end
endmodule
