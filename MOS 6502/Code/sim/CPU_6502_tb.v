module CPU_6502_tb;
    wire [7:0] DATA_FINAL;
    reg RESET;
    reg CLK;
    wire PHI1;
    wire PHI2;
    wire SYNC;
    reg [2:0] SELECT_OUT;
    wire [6:0] seg_1;
    wire [6:0] seg_2 ;
    // wire [7:0] DATA_IN;
    // wire load_A;
    // Instantiate the Unit Under Test (UUT)
    CPU_6502 uut (
    .DATA_FINAL(DATA_FINAL),
    .RESET(RESET),
    .CLK(CLK),
    .PHI1(PHI1),
    .PHI2(PHI2),
    .SYNC(SYNC),
    .SELECT_OUT(SELECT_OUT),
    .seg_1(seg_1),
    .seg_2(seg_2)
        );
    // Paramètres de timing
    parameter CLK_PERIOD = 10;  // 100 MHz

    // Génération de l'horloge principale
    initial CLK = 1;
    always #(CLK_PERIOD/2) CLK = ~CLK;
    // Test sequence
    initial begin
        RESET = 1;
        SELECT_OUT = 1'b000;
        #(CLK_PERIOD*3);
        RESET = 0;
        #(CLK_PERIOD*500);
        $finish;
    end

endmodule



// module CPU_6502_tb;
//     wire [7:0] DATA_OUT;
//     wire [7:0] DATA_OUT_IR;
//     wire OUT_NEGATIF_T;
//     wire OUT_INTERRUPTION_T;
//     wire OUT_OVERFLOW_T;
//     wire OUT_CARRY_T;
//     wire load_IR_internal;
//     wire load_A;
//     wire load_IMM;
//     wire set_Flag;
//     wire alu_enable;
//     wire [7:0] OUT_A;
//     wire [7:0] OUT_IMM;
//     wire [1:0] alu_opcode;
//     wire inc_PC;
//     wire [7:0] DATA_IN;
//     reg RESET;
//     reg CLK;
//     wire PHI1;
//     wire PHI2;
//     wire SYNC;
//     wire  [15:0] OUT_ADRESS_BUS;

//     // Instantiate the Unit Under Test (UUT)
//     CPU_6502 uut (
//     .DATA_OUT(DATA_OUT),
//     .DATA_OUT_IR(DATA_OUT_IR),
//     .OUT_NEGATIF_T(OUT_NEGATIF_T),
//     .OUT_INTERRUPTION_T(OUT_INTERRUPTION_T),
//     .OUT_OVERFLOW_T(OUT_OVERFLOW_T),
//     .OUT_CARRY_T(OUT_CARRY_T),
//     .load_IR_internal(load_IR_internal),
//     .load_A(load_A),
//     .load_IMM(load_IMM),
//     .set_Flag(set_Flag),
//     .alu_enable(alu_enable),
//     .OUT_A(OUT_A),
//     .OUT_IMM(OUT_IMM),
//     .alu_opcode(alu_opcode),
//     .inc_PC(inc_PC),
//     .DATA_IN(DATA_IN),
//     .RESET(RESET),
//     .CLK(CLK),
//     .PHI1(PHI1),
//     .PHI2(PHI2),
//     .address_bus_internal(OUT_ADRESS_BUS),
//     .SYNC(SYNC)
//     );
//     // Paramètres de timing
//     parameter CLK_PERIOD = 10;  // 100 MHz

//     // Génération de l'horloge principale
//     initial CLK = 1;
//     always #(CLK_PERIOD/2) CLK = ~CLK;
//     // Test sequence
//     initial begin
//         RESET = 1;
//         #(CLK_PERIOD);
//         RESET = 0;
//         #(CLK_PERIOD*20);
//         $finish;
//     end

// endmodule