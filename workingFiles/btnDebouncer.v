module btnDebouncer(
    input wire clk1KHz,    // Clock input
    input wire btn1, // Pause Button

    output reg pause,   // Debounced Pause
);

    reg [2:0] stepBtn1;
    reg pauseFlip;

    initial
    begin
        stepBtn1 <= 3'b000;
    end

    // Shift registers for debouncing
    always @(posedge clk1KHz)
    begin
        stepBtn1 <= {btn1, stepBtn1[2:1]};
    end

    // Rising edge detection (Debounced)
    always @(posedge clk1KHz)
    begin
        if (pauseFlip)
        begin
            pause <= ~pause;
            pauseFlip <= 1'b0;
        end
        else 
        begin
            rst   <= ~stepRst[0]   & stepRst[1];
            pauseFlip <= ~stepPause[0] & stepPause[1];
        end
    end

endmodule