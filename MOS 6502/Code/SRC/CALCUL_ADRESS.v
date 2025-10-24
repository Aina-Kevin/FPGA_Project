module CALCUL_ADRESS(
    input      wire       clk,
    input  wire           reset_offset,        // reset du registre offset
    input   wire   [15:0] PC,       
    input wire     [7:0]  offset,             // offset 8 bits signé
    input      wire       load_offset,         // charge le registre quand actif
    input       wire      enable_calcul_adresse, 
    output reg [15:0] ADR_Calcul
);

    // registre pour stocker l'offset 8 bits
    reg signed [7:0] offset_reg;

    always @(posedge clk) begin
        if (reset_offset)
            offset_reg <= 8'sd0;
        else if (load_offset)
            offset_reg <= offset;   
    end

    // addition combinatoire avec PC
    wire [7:0] PC_H, PC_L;
    reg  [7:0] ADR_tmp;

    // Séparation des octets du PC
    assign PC_H = PC[15:8];
    assign PC_L = PC[7:0];

    // Calcul combinatoire
    always @(*) begin
        if (enable_calcul_adresse)
            ADR_tmp = PC_L + $signed(offset_reg);  
        ADR_Calcul = {PC_H, ADR_tmp};            
    end
endmodule
