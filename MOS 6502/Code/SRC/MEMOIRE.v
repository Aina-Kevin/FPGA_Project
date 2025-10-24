module MEMOIRE (
    input wire CLK,
    input wire WRITE_ENABLE,
    input wire READ_ENABLE,
    input wire [15:0] ADRESSE_CPU,
    input wire [7:0] DATA_to_MEMORY_IN,
    output reg [7:0] DATA_MICRO_OUT
);

    reg [15:0] addr_latch = 0;
    reg [7:0] ROM [0:20];   // ROM = adresses 0..20
    reg [7:0] RAM [21:29];    // RAM = adresses 21..30
    reg in_read_latch = 0;
    reg in_write_latch = 0;
    initial begin
        ///  DDEMO 1 
        ///  DDEMO 1 
        ///  DDEMO 1 
        ROM[0]  = 8'h69;
        ROM[1]  = 8'hA9; 
        ROM[2]  = 8'h03; 
        ROM[3]  = 8'hE9;
        ROM[4]  = 8'h01;
        ROM[5]  = 8'h49;
        ROM[6]  = 8'h00;
        ROM[7]  = 8'h09;
        ROM[8]  = 8'hFF;
        ROM[9]  = 8'h29;
        ROM[10]  = 8'hF0;
        ROM[11]  = 8'h4A;
        // ROM[12]  = 8'h2A;
        ///  DDEMO 2 
        ///  DDEMO 2 
        ///  DDEMO 2 
        // ROM[0]  = 8'h69;
        // ROM[1]  = 8'hA9; // LDA #$01
        // ROM[2]  = 8'h01; // Valeur de départ = 1
        // ROM[3]  = 8'h85; // STA $00 (RAM[0] par exemple)
        // ROM[4]  = 8'h14;
        // ROM[5]  = 8'hA5; // LDA $00
        // ROM[6]  = 8'h14;
        // ROM[7]  = 8'h69; // ADC #$01
        // ROM[8]  = 8'h01;
        // ROM[9]  = 8'h85; // STA $00
        // ROM[10] = 8'h14;
        // ROM[11] = 8'hC9; // CMP #$0A
        // ROM[12] = 8'h0A;
        // ROM[13] = 8'hD0; // BNE Loop
        // ROM[14] = 8'hF8; // offset = -7 instructions (retour à LDA $00)
        // ROM[20] = 8'h00;

    end

    // latch synchronisé PHI1
    always @(posedge CLK) begin
        addr_latch    <= ADRESSE_CPU;
        in_read_latch <= READ_ENABLE;
        in_write_latch<= WRITE_ENABLE;
    end

    // accès mémoire synchronisé PHI2
    always @(negedge CLK) begin
        // écriture en RAM
        if (in_write_latch) begin
            if (addr_latch >= 21 && addr_latch <= 30)
                RAM[addr_latch - 21] <= DATA_to_MEMORY_IN;
        end

        // lecture en ROM ou RAM
        if (in_read_latch) begin
            if (addr_latch <= 8'h20)
                DATA_MICRO_OUT <= ROM[addr_latch];
            else if (addr_latch >= 8'h21 && addr_latch <= 8'h30)
                DATA_MICRO_OUT <= RAM[addr_latch - 8'h21];
            else
                DATA_MICRO_OUT <= 8'h00;  // valeurs par défaut
        end
    end
endmodule
