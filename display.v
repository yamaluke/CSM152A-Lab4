`timescale 10ns / 1ns

module display(
    input wire clkDis,
    input wire [4:0] digit1,  // Digit 1 input (e.g., m10)
    input wire [4:0] digit2,  // Digit 2 input (e.g., m1)
    input wire [4:0] digit3,  // Digit 3 input (e.g., s10)
    input wire [4:0] digit4,  // Digit 4 input (e.g., s1)
    output reg [6:0] seg,     // 7-segment display output
    output reg [3:0] an       // 4-digit select output (anode control)
);

    reg [1:0] digit_select;   // For digit multiplexing (0: m10, 1: m1, 2: s10, 3: s1)

    // Multiplexing 7-segment decoder
    always @(posedge clkDis) begin
        case (digit_select)
            2'b00: begin
                // Display minutes tens digit (m10)
                an = 4'b0111;  // Only m10 is active
                case (digit1)
                    4'b0000: seg = 7'b1000000; // 0
                    4'b0001: seg = 7'b1111001; // 1
                    4'b0010: seg = 7'b0100100; // 2
                    4'b0011: seg = 7'b0110000; // 3
                    4'b0100: seg = 7'b0011001; // 4
                    4'b0101: seg = 7'b0010010; // 5
                    4'b0110: seg = 7'b0000010; // 6
                    4'b0111: seg = 7'b1111000; // 7
                    4'b1000: seg = 7'b0000000; // 8
                    4'b1001: seg = 7'b0010000; // 9
                    4'b1010: seg = 7'b0001000; // A
                    4'b1011: seg = 7'b0000011; // B
                    4'b1100: seg = 7'b1000110; // C
                    4'b1101: seg = 7'b0100001; // D
                    4'b1110: seg = 7'b0000110; // E
                    4'b1111: seg = 7'b0001110; // F
                endcase
            end
            2'b01: begin
                // Display minutes ones digit (m1)
                an = 4'b1011;  // Only m1 is active
                case (digit2)
                    4'b0000: seg = 7'b1000000;
                    4'b0001: seg = 7'b1111001;
                    4'b0010: seg = 7'b0100100;
                    4'b0011: seg = 7'b0110000;
                    4'b0100: seg = 7'b0011001;
                    4'b0101: seg = 7'b0010010;
                    4'b0110: seg = 7'b0000010;
                    4'b0111: seg = 7'b1111000;
                    4'b1000: seg = 7'b0000000;
                    4'b1001: seg = 7'b0010000;
                    4'b1010: seg = 7'b0001000; // A
                    4'b1011: seg = 7'b0000011; // B
                    4'b1100: seg = 7'b1000110; // C
                    4'b1101: seg = 7'b0100001; // D
                    4'b1110: seg = 7'b0000110; // E
                    4'b1111: seg = 7'b0001110; // F
                endcase
            end
            2'b10: begin
                // Display seconds tens digit (s10)
                an = 4'b1101;  // Only s10 is active
                case (digit3)
                    4'b0000: seg = 7'b1000000;
                    4'b0001: seg = 7'b1111001;
                    4'b0010: seg = 7'b0100100;
                    4'b0011: seg = 7'b0110000;
                    4'b0100: seg = 7'b0011001;
                    4'b0101: seg = 7'b0010010;
                    4'b0110: seg = 7'b0000010;
                    4'b0111: seg = 7'b1111000;
                    4'b1000: seg = 7'b0000000;
                    4'b1001: seg = 7'b0010000;
                    4'b1010: seg = 7'b0001000; // A
                    4'b1011: seg = 7'b0000011; // B
                    4'b1100: seg = 7'b1000110; // C
                    4'b1101: seg = 7'b0100001; // D
                    4'b1110: seg = 7'b0000110; // E
                    4'b1111: seg = 7'b0001110; // F
                endcase
            end
            2'b11: begin
                // Display seconds ones digit (s1)
                an = 4'b1110;  // Only s1 is active
                case (digit4)
                    4'b0000: seg = 7'b1000000;
                    4'b0001: seg = 7'b1111001;
                    4'b0010: seg = 7'b0100100;
                    4'b0011: seg = 7'b0110000;
                    4'b0100: seg = 7'b0011001;
                    4'b0101: seg = 7'b0010010;
                    4'b0110: seg = 7'b0000010;
                    4'b0111: seg = 7'b1111000;
                    4'b1000: seg = 7'b0000000;
                    4'b1001: seg = 7'b0010000;
                    4'b1010: seg = 7'b0001000; // A
                    4'b1011: seg = 7'b0000011; // B
                    4'b1100: seg = 7'b1000110; // C
                    4'b1101: seg = 7'b0100001; // D
                    4'b1110: seg = 7'b0000110; // E
                    4'b1111: seg = 7'b0001110; // F
                endcase
            end
        endcase

        // Cycle through the digits (m10, m1, s10, s1) with multiplexing
        digit_select <= digit_select + 1;
    end
endmodule
