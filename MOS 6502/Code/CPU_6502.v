module CPU_6502(
    input wire RESET,
    input wire CLK,
    output wire [7:0] DATA_FINAL,
    input wire [2:0] SELECT_OUT,
    output wire PHI1,
    output wire PHI2,
    output wire SYNC,
    output wire [6:0] seg_1,
    output wire [6:0] seg_2 
);

wire SEL_A, SEL_MDR, SEL_IMM, SEL_X, SEL_Y;
wire [2:0] SELECT_DATA;
wire enable_CARRY;
wire SELECT_ADDRESS, read_wire, write_wire;
wire load_MDR, reset_MAR, load_MARH, load_MARL;
wire reset_IMM, reset_A, reset_MDR;
wire reset_N, reset_O, reset_I, reset_C, reset_X, reset_Y;
wire load_X, load_Y;
wire reset_PCH, reset_PCL, load_PCH, load_PCL;
wire load_A, load_IMM;
wire set_Flag;
wire alu_enable;
wire [1:0] alu_opcode;
wire [7:0] DATA_IN;
wire inc_PC;
wire [7:0] OUT_DATA_BUS;
wire [15:0] OUT_ADRESS_BUS;

COMMANDE COMMANDE_i(
  .RESET(RESET),
        .CLK(CLK),
        .PHI1(PHI1),
        .PHI2(PHI2),
        .SYNC(SYNC),
        .DATA_IN(DATA_IN),
        .SEL_A(SEL_A),
        .SEL_MDR(SEL_MDR),
        .SEL_IMM(SEL_IMM),
        .SEL_X(SEL_X),
        .SEL_Y(SEL_Y),
        .SELECT_DATA(SELECT_DATA),
        .enable_CARRY(enable_CARRY),
        .SELECT_ADDRESS(SELECT_ADDRESS),
        .read_wire(read_wire),
        .write_wire(write_wire),
        .load_MDR(load_MDR),
        .reset_MAR(reset_MAR),
        .load_MARH(load_MARH),
        .load_MARL(load_MARL),
        .reset_IMM(reset_IMM),
        .reset_A(reset_A),
        .reset_MDR(reset_MDR),
        .reset_N(reset_N),
        .reset_O(reset_O),
        .reset_I(reset_I),
        .reset_C(reset_C),
        .reset_X(reset_X),
        .reset_Y(reset_Y),
        .load_X(load_X),
        .load_Y(load_Y),
        .reset_PCH(reset_PCH),
        .reset_PCL(reset_PCL),
        .load_PCH(load_PCH),
        .load_PCL(load_PCL),
        .load_A(load_A),
        .load_IMM(load_IMM),
        .set_Flag(set_Flag),
        .alu_enable(alu_enable),
        .alu_opcode(alu_opcode),
        .inc_PC(inc_PC)
);
DATAPATH DATAPATH_i(
    .DATA_IN(DATA_IN),
    .CLK(CLK),
    .SEL_A(SEL_A), 
    .SEL_MDR(SEL_MDR), 
    .SEL_IMM(SEL_IMM), 
    .SEL_X(SEL_X), 
    .SEL_Y(SEL_Y),
    .SELECT_DATA(SELECT_DATA),
    .enable_CARRY(enable_CARRY),
    .SELECT_ADDRESS(SELECT_ADDRESS), 
    .read_wire(read_wire), 
    .write_wire(write_wire),
    .load_MDR(load_MDR), 
    .reset_IMM(reset_IMM), 
    .reset_A(reset_A), 
    .reset_MDR(reset_MDR),
    .reset_N(reset_N), 
    .reset_O(reset_O), 
    .reset_I(reset_I), 
    .reset_C(reset_C), 
    .reset_MAR(reset_MAR), 
    .reset_Y(reset_Y), 
    .reset_X(reset_X),
    .load_MARH(load_MARH), 
    .load_MARL(load_MARL), 
    .load_X(load_X), 
    .load_Y(load_Y),
    .reset_PCH(reset_PCH), 
    .reset_PCL(reset_PCL), 
    .load_PCH(load_PCH), 
    .load_PCL(load_PCL),
    .load_A(load_A),
    .load_IMM(load_IMM),
    .set_Flag(set_Flag),
    .alu_enable(alu_enable),
    .alu_opcode(alu_opcode),
    .inc_PC(inc_PC),
    .OUT_DATA_BUS(OUT_DATA_BUS),
    .OUT_ADRESS_BUS(OUT_ADRESS_BUS),
    .SELECT_OUT(SELECT_OUT),
    .DATA_FINAL(DATA_FINAL)
);
MEMOIRE MEMOIRE_i(
        .CLK(CLK),
        .WRITE_ENABLE(write_wire),
        .READ_ENABLE(read_wire),
        .ADRESSE_CPU(OUT_ADRESS_BUS),
        .DATA_to_MEMORY_IN(OUT_DATA_BUS),
        .DATA_MICRO_OUT(DATA_IN)
);
OUTPUT OUTPUT_i(
    .digit_8(DATA_FINAL),
    .seg_1(seg_1),
    .seg_2(seg_2)
);
endmodule
