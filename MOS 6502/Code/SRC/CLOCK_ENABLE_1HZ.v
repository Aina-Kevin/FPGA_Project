module CLOCK_ENABLE_1HZ(
    input wire CLK,       // 50 MHz
    input wire RESET,
    output reg enable_1Hz
);

    reg [25:0] counter;

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            counter <= 0;
            enable_1Hz <= 0;
        end else if (counter == 49_999_999) begin
            counter <= 0;
            enable_1Hz <= 1;  // active pendant un cycle 50 MHz
        end else begin
            counter <= counter + 1;
            enable_1Hz <= 0;
        end
    end

endmodule
