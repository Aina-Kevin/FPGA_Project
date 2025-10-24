module DATAPATH(
    input wire [7:0] DATA_IN,
    input wire CLK,
    input wire SEL_A, SEL_MDR, SEL_IMM, SEL_X, SEL_Y,calcul_enable,
    input wire [2:0] SELECT_DATA,
    input wire enable_CARRY,
    input wire [1:0] SELECT_ADDRESS,
    input wire read_wire, write_wire,
    input wire load_MDR, reset_IMM, reset_A, reset_MDR,load_offset,reset_offset,
    input wire reset_N, reset_O, reset_I, reset_C,reset_Z ,reset_MAR, reset_Y, reset_X,
    input wire load_MARH, load_MARL, load_X, load_Y,
    input wire reset_PC, load_PC,
    input wire load_A,
    input wire load_IMM,
    input wire set_Flag,
    input wire alu_enable,
    input wire [3:0] alu_opcode,
    input wire inc_PC,
    output wire [7:0] OUT_DATA_BUS,
    output wire [15:0] OUT_ADRESS_BUS,
    output wire [7:0] DATA_FINAL,
    input wire [2:0] SELECT_OUT,
    output wire OUT_CARRY_T ,OUT_ZERO_T , OUT_OVERFLOW_T,OUT_INTERRUPTION_T,OUT_NEGATIF_T
);

    // ----------------------
    // Internal wires
    // ----------------------
    wire [7:0] OUT_A;
    // wire OUT_NEGATIF_T;
    // wire OUT_INTERRUPTION_T;
    // wire OUT_OVERFLOW_T;
    // wire OUT_CARRY_T;
    // wire OUT_ZERO_T;
    wire [15:0] wire_PC;
    wire [15:0] wire_MAR;
    wire [15:0] wire_CALCUL;
    wire [7:0] OUT_IMM;
    wire [7:0] OUT_MDR, Result_AL, OUT_X, OUT_Y;
    wire WIRE_Carry, WIRE_Negatif, WIRE_Overflow, WIRE_INTERRUPTION, WIRE_ZERO;
    // ----------------------
    // MUX inputs
    // ----------------------
    wire [7:0] IN_MUX_A   = SEL_A   ? DATA_IN : OUT_DATA_BUS;
    wire [7:0] IN_MUX_MDR = SEL_MDR ? DATA_IN : OUT_DATA_BUS;
    wire [7:0] IN_MUX_IMM = SEL_IMM ? DATA_IN : OUT_DATA_BUS;
    wire [7:0] IN_MUX_X   = SEL_X   ? DATA_IN : OUT_DATA_BUS;
    wire [7:0] IN_MUX_Y   = SEL_Y   ? DATA_IN : OUT_DATA_BUS;

    reg  [15:0] address_bus_internal;

    // ----------------------
    // Instances
    // ----------------------
    MUX_DATA MUX_DATA_i(
        .OUT_DATA_BUS(OUT_DATA_BUS),
        .OUT_A_MUX(OUT_A),
        .OUT_RESULT_ALU_MUX(Result_AL),
        .OUT_IMM_MUX(OUT_IMM),
        .OUT_MDR_MUX(OUT_MDR),
        .OUT_Y_MUX(OUT_Y),
        .OUT_X_MUX(OUT_X),
        .SELECT_DATA(SELECT_DATA)
    );

    MEMORY_DATA_REGISTER MEMORY_DATA_REGISTER_i(
        .IN_MDR(IN_MUX_MDR),
        .FSM_Signal(CLK),
        .load_MDR(load_MDR),
        .reset_MDR(reset_MDR),
        .OUT_MDR(OUT_MDR)
    );   

    REGISTER_Y REGISTER_Y_i(
        .IN_Y(IN_MUX_Y),
        .FSM_Signal(CLK),
        .load_Y(load_Y),
        .reset_Y(reset_Y),
        .OUT_Y(OUT_Y)
    );    

    REGISTER_X REGISTER_X_i(
        .IN_X(IN_MUX_X),
        .FSM_Signal(CLK),
        .load_X(load_X),
        .reset_X(reset_X),
        .OUT_X(OUT_X)
    );

    REGISTER_A REGISTER_A_i(
        .IN_A(IN_MUX_A),
        .FSM_Signal(CLK),
        .load_A(load_A),
        .reset_A(reset_A),
        .OUT_A(OUT_A)
    );

    REGISTER_IMM REGISTER_IMM_i(
        .IN_IMM(IN_MUX_IMM),
        .FSM_Signal(CLK),
        .load_IMM(load_IMM),
        .reset_IMM(reset_IMM),
        .OUT_IMM(OUT_IMM)
    );

    ALU ALU_i(
        .Source_A(OUT_A),
        .Source_B(OUT_IMM),
        .alu_opcode(alu_opcode),
        .alu_enable(alu_enable),
        .carry_IN(OUT_CARRY_T),
        .enable_CARRY(enable_CARRY),
        .Result(Result_AL),
        .Flag_Carry(WIRE_Carry),
        .Flag_Negatif(WIRE_Negatif),
        .Flag_Overflow(WIRE_Overflow),
        .Flag_ZERO(WIRE_ZERO)
    );

    REGISTER_FLAG REGISTER_FLAG_i(
        .FSM_Signal(CLK),
        .set_flag(set_Flag),
        .reset_CARRY(reset_C),
        .IN_CARRY(WIRE_Carry),
        .OUT_CARRY(OUT_CARRY_T),
        .reset_INTERUPTION(reset_I),
        .IN_INTERUPTION(WIRE_INTERRUPTION),
        .OUT_INTERUPTION(OUT_INTERRUPTION_T),
        .reset_OVERFLOW(reset_O),
        .IN_OVERFLOW(WIRE_Overflow),
        .OUT_OVERFLOW(OUT_OVERFLOW_T),
        .reset_NEGATIF(reset_N),
        .IN_NEGATIF(WIRE_Negatif),
        .OUT_NEGATIF(OUT_NEGATIF_T),
        .reset_ZERO(reset_Z),
        .IN_ZERO(WIRE_ZERO),
        .OUT_ZERO(OUT_ZERO_T)
    );
    MUX_ADRESS MUX_ADRESS_i(
        .SELECT_ADRESS(SELECT_ADDRESS),
        .OUT_PC(wire_PC),
        .OUT_MAR(wire_MAR),
        .ADRESSE_Calcul(wire_CALCUL),
        .OUT_ADRESS_BUS(OUT_ADRESS_BUS)
    );

    MEMORY_ADRESS_REGISTER MEMORY_ADRESS_REGISTER_i(
        .FSM_Signal(CLK),
        .reset_MAR(reset_MAR),    
        .load_MARH(load_MARH),    
        .load_MARL(load_MARL),    
        .IN_HIGH(DATA_IN),      
        .IN_LOW(DATA_IN),
        .OUT_MAR(wire_MAR)
    );

    PROGRAMM_COUNTER PROGRAMM_COUNTER_i(
        .CLK(CLK),           
        .reset_PC(reset_PC),         
        .load_PC(load_PC),      
        .inc_PC(inc_PC),   
        .IN_PC(wire_CALCUL), 
        .OUT_PC(wire_PC)  
    );
    CALCUL_ADRESS CALCUL_ADRESS_i(
        .clk(CLK),
        .load_offset(load_offset),
        .PC(wire_PC),
        .reset_offset(reset_offset),
        .offset(DATA_IN),
        .ADR_Calcul(wire_CALCUL),
        .enable_calcul_adresse(calcul_enable)
    );
    MUX_OUT MUX_OUT_i(
        .OUT_A_to_FPGA(OUT_A),
        .OUT_MDR_to_FPGA(OUT_MDR),
        .OUT_IMM_to_FPGA(OUT_IMM),
        .OUT_Y_to_FPGA(OUT_Y),
        .OUT_X_to_FPGA(OUT_X),
        .SELECT_OUT(SELECT_OUT),     
        .OUT_DATA_BUS_to_FPGA(DATA_FINAL)
);

endmodule
