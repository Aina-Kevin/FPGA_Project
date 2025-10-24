module OUTPUT(
    input wire [7:0] digit_8,
    output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);
    wire [3:0] high_nibble = digit_8[7:4]; // bits 7-4
    wire [3:0] low_nibble  = digit_8[3:0]; // bits 3-0
DECO_BCD DECO_BCD_1(
    .hex_digit(high_nibble),
    .seg(HEX0)
);
DECO_BCD DECO_BCD_2(
    .hex_digit(low_nibble),
    .seg(HEX1)
);
    // assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;
    assign HEX6 = 7'b1111111;
    assign HEX7 = 7'b1111111;
endmodule