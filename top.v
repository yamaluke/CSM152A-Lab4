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

    // Instantiate the Clock Divider module
    clock_divider myCD (
        .clk(clk),              // Main clock input (e.g., 50 MHz)
        .rst(btnR),            // Reset signal
        .clk1KHz(clk1KHz)      // 1 kHz clock output
    );

    // Internal registers to store decoded values
    reg [3:0] dec1, dec2, dec3, dec4;
    
    // Instantiate 4 decoder modules for each keypress
    decoder dec_inst1 (
        .clk_100MHz(clk),
        .row(row),
        .col(col),
        .dec_out(dec1)  // Store the output from the first decoder
    );

    decoder dec_inst2 (
        .clk_100MHz(clk),
        .row(row),
        .col(col),
        .dec_out(dec2)  // Store the output from the second decoder
    );

    decoder dec_inst3 (
        .clk_100MHz(clk),
        .row(row),
        .col(col),
        .dec_out(dec3)  // Store the output from the third decoder
    );

    decoder dec_inst4 (
        .clk_100MHz(clk),
        .row(row),
        .col(col),
        .dec_out(dec4)  // Store the output from the fourth decoder
    );

    // Instantiate the Display module
    display myDisplay (
        .clk1KHz(clk1KHz),      // Clock input for 7-segment multiplexing (1 kHz)
        .digit1(key1),          // First digit input
        .digit2(key2),          // Second digit input
        .digit3(key3),          // Third digit input
        .digit4(key4),          // Fourth digit input
        .seg(seg),              // 7-segment display output
        .an(an)                 // 4-digit anode control output
    );

    // Instantiate the display module and connect the decoded values
    display disp_inst (
        .clk1KHz(clk1KHz),  // Multiplexing clock
        .digit1(dec1),        // First decoded value
        .digit2(dec2),        // Second decoded value
        .digit3(dec3),        // Third decoded value
        .digit4(dec4),        // Fourth decoded value
        .seg(seg),            // 7-segment display output
        .an(an)               // 4-digit select output
    );

endmodule
