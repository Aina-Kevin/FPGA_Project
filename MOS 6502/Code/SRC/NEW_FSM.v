module NEW_FSM (
    input wire CLK,      
    input wire FLAG_OUT_CARRY,
    input wire FLAG_OUT_OVERFLOW,
    input wire FLAG_OUT_NEGATIF,
    input wire FLAG_OUT_INTERUPTION,
    input wire FLAG_OUT_ZERO,     
    input wire RESET,         
    input wire [7:0] OUTPUT_IR, 
    output reg [1:0] SELECT_ADDRESS,
    output reg read,
    output reg write,
    output reg inc_PC,
    output reg calcul_enable,
    output reg load_IR,
    output reg [2:0] SELECT_DATA,
    output reg load_IMM,
    output reg SEL_IMM,
    output reg alu_enable,
    output reg [3:0] alu_opcode,
    output reg enable_CARRY,
    output reg SEL_A,
    output reg load_A,
    output reg set_Flag,
    output reg load_MARH,
    output reg load_MARL,
    output reg load_MDR,    
    output reg load_PC, 
    output reg reset_IMM,
    output reg reset_A,
    output reg reset_MDR,
    output reg reset_N,
    output reg reset_O,
    output reg reset_I,
    output reg reset_C,
    output reg reset_Z,
    output reg reset_IR,
    output reg reset_PC,
    output reg reset_MAR,
    output reg load_offset,
    output reg reset_offset,
    output wire PHI1,
    output wire PHI2,
    output reg SYNC,
    output reg reset_X,
    output reg reset_Y,
    output reg load_X,
    output reg load_Y,
    output reg SEL_X,
    output reg SEL_Y,
    output reg SEL_MDR
);

    // ETAT POSSIBLE
    parameter FETCH_OPCODE  = 2'b00;
    parameter FETCH_OPERAND = 2'b01;
    parameter MEM_ACCESS    = 2'b10;
    parameter EXECUTE       = 2'b11;

    // Registres d'état
    reg [1:0] current_state, next_state;
    reg phase; // 0 pour PHI1, 1 pour PHI2
    
    // Sortie PHI1 et PHI2 dérivées de phase
    assign PHI1 = ~phase;
    assign PHI2 =  phase;

    // Signaux décodés
    wire add_imm       = (OUTPUT_IR == 8'h69);
    wire sub_imm       = (OUTPUT_IR == 8'hE9);
    wire ora_imm       = (OUTPUT_IR == 8'h09);
    wire anda_imm       = (OUTPUT_IR == 8'h29);
    wire xora_imm       = (OUTPUT_IR == 8'h49);
    wire add_zeroPage  = (OUTPUT_IR == 8'h65);
    wire sub_zeroPage  = (OUTPUT_IR == 8'hE5);
    wire ora_zeroPage  = (OUTPUT_IR == 8'h05);
    wire anda_zeroPage  = (OUTPUT_IR == 8'h25);
    wire xora_zeroPage  = (OUTPUT_IR == 8'h45);

    wire loadA_imm     = (OUTPUT_IR == 8'hA9);
    wire loadA_zeroPage = (OUTPUT_IR == 8'hA5); 

    wire loadX_imm     = (OUTPUT_IR == 8'hA2);
    wire loadX_zeroPage = (OUTPUT_IR == 8'hA6); 

    wire loadY_imm     = (OUTPUT_IR == 8'hA0);
    wire loadY_zeroPage = (OUTPUT_IR == 8'hA4);

    wire storeA_zeroPage = (OUTPUT_IR == 8'h85);
    wire BEQ       = (OUTPUT_IR == 8'hF0);
    wire BNE       = (OUTPUT_IR == 8'hD0);
    wire CMP_imm       = (OUTPUT_IR == 8'hC9);
    wire CMP_zeropage       = (OUTPUT_IR == 8'hC5);
    wire LSR_IMP       = (OUTPUT_IR == 8'h4A);
    wire ASL_IMP       = (OUTPUT_IR == 8'h0A);
    wire ROR_IMP       = (OUTPUT_IR == 8'h6A);
    wire ROL_IMP       = (OUTPUT_IR == 8'h2A);

    // Logique séquentielle 
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            current_state <= FETCH_OPCODE;
            phase <= 1;
        end else begin
            phase <= ~phase; // Alterne entre PHI1 et PHI2
            if (phase) begin // Transition d'état seulement en PHI2
                current_state <= next_state;
            end
        end
    end
    // Gestion continue des reset
    always @(*) begin
        if (RESET) begin
            reset_A = 1;
            reset_IMM = 1;
            reset_MDR = 1;
            reset_N = 1;
            reset_O = 1;
            reset_I = 1;
            reset_C = 1;
            reset_Z = 1;
            reset_IR = 1;
            reset_PC = 1;
            reset_MAR = 1;
            reset_X = 1;
            reset_Y = 1;
            reset_offset =1;
        end else begin
            reset_A = 0;
            reset_IMM = 0;
            reset_MDR = 0;
            reset_N = 0;
            reset_O = 0;
            reset_I = 0;
            reset_C = 0;
            reset_Z = 0;
            reset_IR = 0;
            reset_PC = 0;
            reset_MAR = 0;
            reset_X = 0;
            reset_Y = 0;
            reset_offset = 0;
        end
    end

    // Prochain état (calculé en PHI2)
    always @(*) begin
        case (current_state)
            FETCH_OPCODE: begin
                if (add_imm || sub_imm || add_zeroPage || sub_zeroPage || loadA_zeroPage 
                 || loadA_imm || loadX_imm || loadY_imm || storeA_zeroPage || ora_imm || anda_imm || xora_imm
                 || ora_zeroPage || anda_zeroPage || xora_zeroPage || BNE 
                 || BEQ || CMP_imm || CMP_zeropage)
                    next_state = FETCH_OPERAND;
                else if ( LSR_IMP || ASL_IMP || ROR_IMP 
                || ROL_IMP)
                    next_state = EXECUTE;
                else
                    next_state = FETCH_OPCODE;
            end

            FETCH_OPERAND: begin
                if (add_zeroPage || sub_zeroPage || loadA_zeroPage || loadX_zeroPage || loadY_zeroPage || storeA_zeroPage 
                || ora_zeroPage || anda_zeroPage || xora_zeroPage || CMP_zeropage)
                    next_state = MEM_ACCESS;
                else if (loadA_imm || loadX_imm || loadY_imm)
                    next_state = FETCH_OPCODE;
                else 
                    next_state = EXECUTE; 
            end
            
            MEM_ACCESS: begin
                if (loadA_zeroPage || storeA_zeroPage || loadX_zeroPage || loadY_zeroPage)
                    next_state = FETCH_OPCODE;
                else 
                    next_state = EXECUTE; 
            end
            
            EXECUTE: begin
                next_state = FETCH_OPCODE;
            end

            default: next_state = FETCH_OPCODE;
        endcase
    end

    // Sorties 
    always @(*) begin
        // Valeurs par défaut
        /*inc_PCH = 0;       
        inc_PCL = 0; */      
        load_PC = 0; 
        load_offset = 0;
        read = 0;
        calcul_enable = 0;
        inc_PC = 0;
        load_IR = 0;
        enable_CARRY = 0;
        set_Flag = 0;
        alu_enable = 0;
        SEL_A = 0;
        SEL_X = 0;
        SEL_Y = 0;
        SEL_MDR = 0;
        load_A = 0;
        load_MARH = 0;
        load_MARL = 0;
        load_IMM = 0;
        SEL_IMM = 0;
        SELECT_DATA = 3'b000;  // Changé de 2'b00 à 3'b000 pour correspondre à la déclaration [2:0]
        // alu_opcode = 2'b00;
        // SELECT_ADDRESS = 2'b00;
        SYNC = 0;
        load_X = 0;
        load_Y = 0;
        write = 0;
        load_MDR = 0;  // Ajouté car manquait dans les valeurs par défaut
        
        if (!RESET) begin
            case (current_state)
                FETCH_OPCODE: begin
                    if (!phase) begin // PHI1
                        SELECT_ADDRESS = 2'b00; // PC
                        read = 1;
                        SYNC = 1;
                    end else begin // PHI2
                        inc_PC = 1;
                        load_IR = 1;
                    end
                end

                FETCH_OPERAND: begin
                    if (!phase) begin // PHI1
                        SELECT_ADDRESS = 2'b00; // PC
                        read = 1;
                    end else begin // PHI2
                        read = 1;
                        inc_PC = 1;
                        if (add_zeroPage || sub_zeroPage || loadA_zeroPage || loadX_zeroPage || loadY_zeroPage || storeA_zeroPage 
                        || ora_zeroPage || anda_zeroPage || xora_zeroPage || CMP_zeropage) begin
                            load_MARL = 1;
                        end
                        if (add_imm || sub_imm || ora_imm || anda_imm || xora_imm || CMP_imm) begin
                            SEL_IMM = 1;
                            load_IMM = 1'b1;
                        end
                        if (loadA_imm) begin 
                            SEL_A = 1;
                            load_A = 1;
                        end
                        if (loadX_imm) begin 
                            SEL_X = 1;
                            load_X = 1;
                        end
                        if (loadY_imm) begin 
                            SEL_Y = 1;
                            load_Y = 1;
                        end
                        if (BNE || BEQ) begin 
                            load_offset = 1;
                        end
                    end
                end
                MEM_ACCESS: begin
                    if (!phase) begin // PHI1
                        SELECT_ADDRESS = 2'b01; // MDR
                        if (loadA_zeroPage || loadX_zeroPage || loadY_zeroPage || add_zeroPage || sub_zeroPage || ora_zeroPage 
                        || anda_zeroPage || xora_zeroPage || CMP_zeropage) begin
                            read = 1;
                        end 
                        if (storeA_zeroPage) begin
                            SELECT_DATA = 3'b000; // OUT_A
                            write = 1;
                        end 
                    end else begin // PHI2
                        if (storeA_zeroPage) begin  
                            SELECT_ADDRESS = 2'b01; // MDR
                            SELECT_DATA = 3'b000; // OUT_A/
                            write = 1;
                        end
                        if (loadA_zeroPage) begin 
                            SEL_A = 1;
                            load_A = 1;
                        end
                        if (loadX_zeroPage) begin 
                            SEL_X = 1;
                            load_X = 1;
                        end
                        if (loadY_zeroPage) begin 
                            SEL_Y = 1;
                            load_Y = 1;
                        end
                        if (add_zeroPage || sub_zeroPage || ora_zeroPage || anda_zeroPage || xora_zeroPage || CMP_zeropage) begin
                            SEL_IMM = 1;
                            load_IMM = 1'b1;
                        end
                    end
                end
                EXECUTE: begin
                    if (!phase) begin // PHI1:
                        if (add_imm || sub_imm || add_zeroPage || sub_zeroPage || ora_imm || anda_imm || xora_imm
                        || ora_zeroPage || anda_zeroPage || xora_zeroPage || CMP_zeropage || CMP_imm || LSR_IMP || ASL_IMP || ROR_IMP 
                        || ROL_IMP) begin
                            enable_CARRY = 1;
                            if (add_imm || add_zeroPage) alu_opcode = 4'b0000;
                            else if (sub_imm || sub_zeroPage) alu_opcode = 4'b0001;
                            else if (anda_imm || anda_zeroPage) alu_opcode = 4'b0010;
                            else if (ora_imm || ora_zeroPage) alu_opcode = 4'b0011;
                            else if (xora_imm || xora_zeroPage) alu_opcode = 4'b0100;
                            else if (CMP_imm || CMP_zeropage) alu_opcode = 4'b0101;
                            else if (LSR_IMP) alu_opcode = 4'b0111;
                            else if (ASL_IMP) alu_opcode = 4'b0110;
                            else if (ROR_IMP) alu_opcode = 4'b1001;
                            else if (ROL_IMP) alu_opcode = 4'b1000;
                        end
                        if (BNE || BEQ) begin 
                            calcul_enable = 1;
                        end
                    end else begin // PHI2
                        if (add_imm || sub_imm || add_zeroPage || sub_zeroPage || ora_imm || anda_imm 
                        || ora_zeroPage || anda_zeroPage || xora_imm || xora_zeroPage ||  LSR_IMP || ASL_IMP || ROR_IMP 
                        || ROL_IMP) begin
                            set_Flag = 1;
                            alu_enable = 1;
                            SELECT_DATA = 3'b001;  // Changé de 2'b01 à 3'b001
                            SEL_A = 0;
                            load_A = 1;
                        end
                        if (CMP_imm || CMP_zeropage)begin
                            set_Flag = 1;
                            alu_enable = 1;
                        end
                        if (BEQ || BNE) begin 
                            if (BEQ && FLAG_OUT_ZERO) 
                                load_PC = 1;
                            else if (BNE && !FLAG_OUT_ZERO) 
                                load_PC = 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule

