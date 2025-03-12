`timescale 10ns / 1ns

module twoBitCounter(
    input wire clk,          // Clock input
    output reg d1,              // first digit
    output reg d2               // second digit
);

    initial begin
        d1 = 0; // Initial value for d1
        d2 = 0; // Initial value for d2
    end

    // On each clock cycle, increment the counter
    always @(posedge clk) begin
        // Increment d2
        if (d2 == 1) begin
            d2 <= 0;        // Reset d2 to 0
            d1 <= d1 + 1;   // Increment d1
        end else begin
            d2 <= d2 + 1;   // Increment d2
        end
    end

endmodule
