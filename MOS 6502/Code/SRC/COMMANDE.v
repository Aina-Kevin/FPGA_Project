module COMMANDE(
    input wire RESET,
    input wire CLK,
    output wire PHI1,
    output wire PHI2,
    output wire SYNC,
    input wire [7:0] DATA_IN,
    input wire FLAG_OUT_CARRY,
    input wire FLAG_OUT_OVERFLOW,
    input wire FLAG_OUT_NEGATIF,
    input wire FLAG_OUT_INTERUPTION,
    input wire FLAG_OUT_ZERO,
    
    // ----------------------
    // Datapath selectors
    // ----------------------
    output wire SEL_A,
    output wire SEL_MDR,
    output wire SEL_IMM,
    output wire SEL_X,
    output wire SEL_Y,
    output wire calcul_enable,
    output wire [2:0] SELECT_DATA,
    output wire enable_CARRY,
    
    // ----------------------
    // Memory control
    // ----------------------
    output wire [1:0] SELECT_ADDRESS,
    output wire read_wire,
    output wire write_wire,
    output wire load_MDR,
    output wire reset_MAR,
    output wire load_MARH,
    output wire load_MARL,
    output wire wire_load_offset,
    output wire wire_reset_offset,
    
    // ----------------------
    // Register resets/loads
    // ----------------------
    output wire reset_IMM,
    output wire reset_A,
    output wire reset_MDR,
    output wire reset_N,
    output wire reset_O,
    output wire reset_I,
    output wire reset_C,
    output wire reset_Z,
    output wire reset_X,
    output wire reset_Y,
    output wire load_X,
    output wire load_Y,
    output wire reset_PC,
    output wire load_PC,
    // ----------------------
    // ALU & flags
    // ----------------------
    output wire load_A,
    output wire load_IMM,
    output wire set_Flag,
    output wire alu_enable,
    output wire [3:0] alu_opcode,
    
    // ----------------------
    // Program counter
    // ----------------------
    output wire inc_PC
);

    // ----------------------
    // Internal wires
    // ----------------------
    wire reset_IR;
    wire [7:0] DATA_OUT_IR;
    wire load_IR_internal;

    // ----------------------
    // Instruction register
    // ----------------------
    INSTRUCTION_REGISTER INSTRUCTION_REGISTER_i(
        .FSM_Signal(CLK),
        .IN_IR(DATA_IN),
        .load_IR(load_IR_internal),
        .reset_IR(reset_IR),
        .OUT_IR(DATA_OUT_IR)
    );

    // ----------------------
    // Finite state machine
    // ----------------------
    NEW_FSM NEW_FSM_i(
        .CLK(CLK),
        .OUTPUT_IR(DATA_OUT_IR),
        .SELECT_ADDRESS(SELECT_ADDRESS),
        .read(read_wire),
        .write(write_wire),
        .load_IR(load_IR_internal),
        .SELECT_DATA(SELECT_DATA),
        .load_IMM(load_IMM),
        .SEL_IMM(SEL_IMM),
        .alu_enable(alu_enable),
        .alu_opcode(alu_opcode),
        .enable_CARRY(enable_CARRY),
        .SEL_A(SEL_A),
        .SEL_X(SEL_X),
        .SEL_Y(SEL_Y),
        .SEL_MDR(SEL_MDR),
        .load_A(load_A),
        .set_Flag(set_Flag),
        .load_MDR(load_MDR),
        .reset_IMM(reset_IMM),
        .reset_A(reset_A),
        .reset_MDR(reset_MDR),
        .reset_N(reset_N),
        .reset_O(reset_O),
        .reset_I(reset_I),
        .reset_C(reset_C),
        .reset_Z(reset_Z),
        .reset_IR(reset_IR),
        .PHI1(PHI1),
        .PHI2(PHI2),
        .RESET(RESET),
        .reset_PC(reset_PC),         
        .load_PC(load_PC),          
        .inc_PC(inc_PC),  
        .reset_MAR(reset_MAR),
        .load_MARH(load_MARH),    
        .load_MARL(load_MARL),
        .SYNC(SYNC),
        .load_X(load_X),
        .load_Y(load_Y),
        .reset_X(reset_X),
        .reset_Y(reset_Y),
        .FLAG_OUT_CARRY(FLAG_OUT_CARRY),
        .FLAG_OUT_OVERFLOW(FLAG_OUT_OVERFLOW),
        .FLAG_OUT_NEGATIF(FLAG_OUT_NEGATIF),
        .FLAG_OUT_INTERUPTION(FLAG_OUT_INTERUPTION),
        .FLAG_OUT_ZERO(FLAG_OUT_ZERO),
        .calcul_enable(calcul_enable),
        .load_offset(wire_load_offset),
        .reset_offset(wire_reset_offset)
    );

endmodule
