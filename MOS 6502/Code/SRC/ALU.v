module ALU (
    input wire [7:0] Source_A,
    input wire [7:0] Source_B,
    input wire [3:0] alu_opcode,      
    input wire        alu_enable,
    input wire      carry_IN,
    input wire       enable_CARRY,
    output reg [7:0] Result,
    output reg       Flag_Negatif,
    output reg       Flag_Overflow,
    output reg       Flag_Carry,
    output reg       Flag_ZERO
);

    reg [8:0] temp_result;
    wire carry_eff;
    assign carry_eff = enable_CARRY ? carry_IN : 1'b0;
    reg old_carry;

always @(*) begin
    if (alu_enable) begin
        case (alu_opcode)
            4'b0000: begin 
                temp_result = {1'b0, Source_A} + {1'b0, Source_B} + carry_eff;
                Result      = temp_result[7:0];
                Flag_Carry  = temp_result[8];
                Flag_Overflow = (~Source_A[7] & ~Source_B[7] & Result[7]) |
                                ( Source_A[7] &  Source_B[7] & ~Result[7]);
                Flag_Negatif = Result[7];
                Flag_ZERO     = (Result == 8'b0);   
            end
            4'b0001: begin  
                  temp_result = {1'b0, Source_A} - {1'b0, Source_B} - (1'b1 - carry_eff);
                  Result      = temp_result[7:0];
                  Flag_Carry  = ~temp_result[8]; 
                  Flag_Overflow = ( Source_A[7] & ~Source_B[7] & ~Result[7]) |
                                  (~Source_A[7] &  Source_B[7] &  Result[7]);
                  Flag_Negatif = Result[7];
                  Flag_ZERO     = (Result == 8'b0);   
            end
            4'b0010: begin  
                    Result       = Source_A & Source_B;
                    Flag_Carry   = 0;
                    Flag_Overflow = 0;
                    Flag_Negatif = Result[7];
                    Flag_ZERO     = (Result == 8'b0);   
                end
            4'b0011: begin  
                    Result       = Source_A | Source_B;
                    Flag_Carry   = 0;
                    Flag_Overflow = 0;
                    Flag_Negatif = Result[7];
                    Flag_ZERO     = (Result == 8'b0);   
                end
            4'b0100: begin  
                    Result        = Source_A ^ Source_B;   
                    Flag_Carry    = 0;                     
                    Flag_Overflow = 0;                     
                    Flag_Negatif  = Result[7];   
                    Flag_ZERO     = (Result == 8'b0);          
                end
            4'b0101: begin  
                    temp_result   = {1'b0, Source_A} - {1'b0, Source_B};
                    Result        = temp_result[7:0];
                    Flag_Carry    = ~temp_result[8]; 
                    Flag_Negatif  = Result[7];
                    Flag_ZERO     = (Result == 8'b0);   
            end
            4'b0110: begin  //  ASL
                    Flag_Carry   = Source_A[7];
                    Result       = Source_A << 1;
                    Flag_ZERO    = (Result == 8'b0);
                    Flag_Negatif = Result[7];
            end
            4'b0111: begin  // LSR
                    Flag_Carry   = Source_A[0];
                    Result       = Source_A >> 1;
                    Flag_ZERO    = (Result == 8'b0);
                    Flag_Negatif = Result[7];
            end
            4'b1000: begin  // ROL
                old_carry = Flag_Carry;          // mémorise l’ancien carry
                Flag_Carry = Source_A[7];             // bit7 de Source_A → nouveau Carry
                Result     = (Source_A << 1) | old_carry; // ancien Carry → bit0
                Flag_ZERO    = (Result == 8'b0);
                Flag_Negatif = Result[7];
            end

            4'b1001: begin  // ROR
                Flag_Carry = Source_A[0];                  // bit0 devient Carry
                Result     = (Source_A >> 1) | (Flag_Carry << 7); // bit7 = ancien Carry
                Flag_ZERO    = (Result == 8'b0);
                Flag_Negatif = Result[7];
            end
                default: begin
                    Result       = 8'b0;
                    Flag_Carry   = 0;
                    Flag_Overflow = 0;
                    Flag_Negatif = 0;
                    Flag_ZERO =0;
                end
            endcase
        end else begin
            Result       = 8'b0;
            Flag_Carry   = 0;
            Flag_Overflow = 0;
            Flag_Negatif = 0;
            Flag_ZERO = 0;
        end
    end

endmodule
