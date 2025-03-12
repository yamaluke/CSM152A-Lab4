`timescale 10ns / 1ns
module top_module(
    input wire clk,         // Main clock input
    output wire [1:0] count // Counter output
);

    // Instantiate the 2-bit counter
    counter my_counter (
        .clk(clk),        // Connect the clock input
        .count(count)     // Connect the counter output
    );

endmodule
