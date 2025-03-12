`timescale 10ns / 1ns

module display2(
    input wire clk1KHz,
    input wire digit1,      // Digit 1 input
    input wire digit2,      // Digit 2 input
    output reg [3:0] seg,   // 7-segment display output
    output reg an           // 2-digit select output (anode control)
);

    reg digit_select;           // low for Digit 1, High for Digit 2

    always @(posedge clk1KHz) begin
        case (digit_select)
            1'b0: begin
                // Display minutes tens digit (m10)
                an = 1'b0;  // Only first digit active
                case (digit1)
                    1'b0: seg = 7'b1000000; // 0
                    1'b1: seg = 7'b1111001; // 1
                endcase
            end
            1'b1: begin
                // Display minutes ones digit (m1)
                an = 4'b1011;  // Only second digit active
                case (digit2)
                    1'b0: seg = 7'b1000000;
                    1'b1: seg = 7'b1111001;
                endcase
            end
        endcase
        // Cycle through the digits (m10, m1, s10, s1) with multiplexing
        digit_select <= digit_select + 1;
    end
    
endmodule