`timescale 10ns / 1ns

module Top(
    input clk,           // Main clock input (e.g., 50 MHz or other)
    input reset,         // Reset input
    input [3:0] row,     // Row inputs from the keypad
    output [3:0] col,    // Column outputs to the keypad
    output [6:0] seg,    // 7-segment display output
    output [3:0] an      // 4-digit anode control output (for multiplexing)
);

    // Internal wires for the key outputs
    wire [3:0] key1, key2, key3, key4;
    wire clk1KHz;

    // Instantiate the Clock Divider module
    clock_divider myCD (
        .clk(clk),              // Main clock input (e.g., 50 MHz)
        .rst(reset),            // Reset signal
        .clk1KHz(clk1KHz)      // 1 kHz clock output
    );

    // Instantiate the Keypad module
    Keypad myKeypad (
        .clk1KHz(clk1KHz),      // Clock input for keypad scanning (1 kHz)
        .reset(reset),          // Reset signal
        .row(row),              // Row inputs from the keypad
        .col(col),              // Column outputs to the keypad
        .key1(key1),            // First key output
        .key2(key2),            // Second key output
        .key3(key3),            // Third key output
        .key4(key4)             // Fourth key output
    );

    // Instantiate the Display module
    display myDisplay (
        .clk1KHz(clk1KHz),      // Clock input for 7-segment multiplexing (1 kHz)
        .digit1(key1),          // First digit input (minutes tens)
        .digit2(key2),          // Second digit input (minutes ones)
        .digit3(key3),          // Third digit input (seconds tens)
        .digit4(key4),          // Fourth digit input (seconds ones)
        .seg(seg),              // 7-segment display output
        .an(an)                 // 4-digit anode control output
    );

endmodule
