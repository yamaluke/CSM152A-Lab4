`timescale 10ns / 1ns

module Top(
    input clk,           // Main clock input (e.g., 50 MHz or other)
    input btnR,         // Reset input
    input [3:0] row,     // Row inputs from the keypad
    output [3:0] col,    // Column outputs to the keypad
    output [6:0] seg,    // 7-segment display output
    output [3:0] an      // 4-digit anode control output (for multiplexing)
);

    // // Internal wires for the key outputs
    // wire [3:0] key1, key2, key3, key4;
    wire clk1KHz;
    wire [3:0] dec_out;
    wire [7:0] input_count;

    // Instantiate the Clock Divider module
    clock_divider myCD (
        .clk(clk),              // Main clock input (e.g., 50 MHz)
        .clk1KHz(clk1KHz)      // 1 kHz clock output
    );

    // Internal registers to store decoded values
    wire [3:0] dec1, dec2, dec3, dec4;
    
    decoder2 my_d2 (
        .clk_100MHz(clk),
        .row(row),
        .col(col),
        .dec_out(dec_out),
        .press_count(input_count)
    )

    // Instantiate the display module and connect the decoded values
    display my_disTest (
        .clk1KHz(clk1KHz),  // Multiplexing clock
        .digit1(input_count),        // First decoded value
        .digit2(dec2),        // Second decoded value
        .digit3(dec3),        // Third decoded value
        .digit4(dec4),        // Fourth decoded value
        .seg(seg),            // 7-segment display output
        .an(an)               // 4-digit select output
    );

endmodule
