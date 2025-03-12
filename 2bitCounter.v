`timescale 10ns / 1ns

module counter(
    input wire clk,          // Clock input
    output reg [1:0] count  // 2-bit counter output
);

    // On each clock cycle, increment the counter
    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2'b11) begin
            count <= 2'b00;  // Reset the counter to 00 after 11
        end
    end

endmodule
