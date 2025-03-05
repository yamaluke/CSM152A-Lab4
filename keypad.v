module Keypad_Scanner (
    input wire clk,              // Clock input
    input wire reset,            // Reset input
    input wire [3:0] row_raw,    // Raw row inputs from the keypad
    output reg [3:0] col,        // Column outputs to the keypad
    output reg [4:0] key         // Output which key is pressed (5-bit register)
);

    // Wire to hold the debounced row signals
    wire [3:0] row_debounced;

    // Instantiate the debouncer for each row (row_raw are the raw inputs from keypad)
    Keypad_Debouncer debounce0 (
        .clk(clk),
        .reset(reset),
        .key_raw(row_raw[0]),
        .key_debounced(row_debounced[0])
    );

    Keypad_Debouncer debounce1 (
        .clk(clk),
        .reset(reset),
        .key_raw(row_raw[1]),
        .key_debounced(row_debounced[1])
    );

    Keypad_Debouncer debounce2 (
        .clk(clk),
        .reset(reset),
        .key_raw(row_raw[2]),
        .key_debounced(row_debounced[2])
    );

    Keypad_Debouncer debounce3 (
        .clk(clk),
        .reset(reset),
        .key_raw(row_raw[3]),
        .key_debounced(row_debounced[3])
    );

    // State machine or scanning logic to handle keypad inputs
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= 2'b00;
        else
            current_state <= next_state;
    end

    // Keypad scanning logic based on the debounced rows
    always @(*) begin
        case (current_state)
            2'b00: begin
                col = 4'b1110;   // Enable column 0
                next_state = (row_debounced[0]) ? 2'b01 : 2'b00;  // Check if debounced row 0 is pressed
            end
            2'b01: begin
                col = 4'b1101;   // Enable column 1
                next_state = (row_debounced[1]) ? 2'b10 : 2'b01;  // Check if debounced row 1 is pressed
            end
            2'b10: begin
                col = 4'b1011;   // Enable column 2
                next_state = (row_debounced[2]) ? 2'b11 : 2'b10;  // Check if debounced row 2 is pressed
            end
            2'b11: begin
                col = 4'b0111;   // Enable column 3
                next_state = (row_debounced[3]) ? 2'b00 : 2'b11;  // Check if debounced row 3 is pressed
            end
            default: next_state = 2'b00;
        endcase
    end

    // Output key detection based on the debounced rows
    always @(posedge clk) begin
        case (current_state)
            2'b00: key = (row_debounced[0]) ? 5'b00001 : 5'b00000; // Key 1 if debounced row 0 is pressed
            2'b01: key = (row_debounced[1]) ? 5'b00010 : 5'b00000; // Key 2 if debounced row 1 is pressed
            2'b10: key = (row_debounced[2]) ? 5'b00100 : 5'b00000; // Key 3 if debounced row 2 is pressed
            2'b11: key = (row_debounced[3]) ? 5'b01000 : 5'b00000; // Key 4 if debounced row 3 is pressed
            default: key = 5'b00000;
        endcase
    end

    // Store the key input into a 5-bit register
    reg [4:0] stored_key;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_key <= 5'b00000; // Clear stored key on reset
        end else if (key != 5'b00000) begin
            stored_key <= key; // Store the key if a key is pressed
        end
    end

endmodule
