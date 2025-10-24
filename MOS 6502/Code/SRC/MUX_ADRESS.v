module MUX_ADRESS (
    input  wire [15:0] OUT_PC,
    input  wire [15:0] OUT_MAR,
    input  wire [15:0] ADRESSE_Calcul,
    input  wire [1:0] SELECT_ADRESS,
    output reg  [15:0] OUT_ADRESS_BUS
);

    always @(*) begin
        case (SELECT_ADRESS)
            2'b00: OUT_ADRESS_BUS = OUT_PC;
            2'b01: OUT_ADRESS_BUS = OUT_MAR;
            2'b10: OUT_ADRESS_BUS = ADRESSE_Calcul;
            default: OUT_ADRESS_BUS = 16'b0;
        endcase
    end

endmodule
