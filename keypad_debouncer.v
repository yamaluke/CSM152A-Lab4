module Keypad_Debouncer (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire key_raw,       // Raw input from the keypad (key pressed or not)
    output reg key_debounced  // Debounced key output (valid key press)
);

    // 2-bit register to store previous key states
    reg [1:0] key_state;

    // Debounce logic using 2-bit register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            key_state <= 2'b00;    // Initialize state to no key press
            key_debounced <= 0;    // No key press initially
        end else begin
            // Shift the current key state into the 2-bit register
            key_state <= {key_state[0], key_raw};

            // Detect stable key press: check if state has changed from 0 to 1 (press)
            if (key_state == 2'b01) begin
                key_debounced <= 1;  // Key press detected
            end else if (key_state == 2'b10) begin
                key_debounced <= 0;  // Key release detected
            end
        end
    end

endmodule
