module REGISTER_FLAG (
    input  wire        FSM_Signal,
    input  wire        set_flag,

    input  wire        IN_NEGATIF,
    input  wire        reset_NEGATIF,
    output reg         OUT_NEGATIF,

    input  wire        IN_OVERFLOW,
    input  wire        reset_OVERFLOW,
    output reg         OUT_OVERFLOW,

    input  wire        IN_INTERUPTION,
    input  wire        reset_INTERUPTION,
    output reg         OUT_INTERUPTION,

    input  wire        IN_CARRY,
    input  wire        reset_CARRY,
    output reg         OUT_CARRY,
    
    input  wire        IN_ZERO,
    input  wire        reset_ZERO,
    output reg         OUT_ZERO
);

    always @(negedge FSM_Signal) begin
       // OUT_NEGATIF = OUT_NEGATIF;
        if (reset_NEGATIF)
            OUT_NEGATIF = 0;
        else if ( set_flag)
            OUT_NEGATIF = IN_NEGATIF;
    end

    always @(negedge FSM_Signal) begin
        //OUT_OVERFLOW = OUT_OVERFLOW;
        if (reset_OVERFLOW)
            OUT_OVERFLOW = 0;
        else if ( set_flag)
            OUT_OVERFLOW = IN_OVERFLOW;
    end

    always @(negedge FSM_Signal) begin
        //OUT_INTERUPTION = OUT_INTERUPTION;
        if (reset_INTERUPTION)
            OUT_INTERUPTION = 0;
        else if ( set_flag)
            OUT_INTERUPTION = IN_INTERUPTION;
    end

    always @(negedge FSM_Signal) begin
        //OUT_CARRY = OUT_CARRY;
        if (reset_CARRY)
            OUT_CARRY = 0;
        else if ( set_flag)
            OUT_CARRY = IN_CARRY;
    end

    always @(negedge FSM_Signal) begin
        //OUT_CARRY = OUT_CARRY;
        if (reset_ZERO)
            OUT_ZERO = 0;
        else if ( set_flag)
            OUT_ZERO = IN_ZERO;
    end

endmodule

