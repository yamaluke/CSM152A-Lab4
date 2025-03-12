`timescale 10ns / 1ns

module test(
    input wire clk,         // Main clock input
    output wire [6:0] seg2,
    output wire an2
);

    wire clk1KHz;
    wire clk1Hz;
    wire d1;
    wire d2;

    clock_divider mCD (
        .clk(clk),
        .clk(clk1Hz),
        .clk1KHz(clk1KHz)
    )

    // Instantiate the 2-bit counter
    twoBitCounter my2BC (
        .clk(clk1Hz),        // Connect the clock input
        .d1(d1),
        .d2(d2)
    );

    display2 my2D (
        .clk(clk1KHz),
        .digit1(d1),
        .digit2(d2),
        .seg(seg2),
        .an(an2)
    )

endmodule
