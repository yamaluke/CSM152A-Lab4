`timescale 10ns / 1ns

module Keypad (
    input wire clk1KHz,              // Clock input
    input wire reset,            // Reset input
    input wire [3:0] row,    // Raw row inputs from the keypad
    output reg [3:0] col,        // Column outputs to the keypad
    output reg [3:0] key1,       // Output for first key press
    output reg [3:0] key2,       // Output for second key press
    output reg [3:0] key3,       // Output for third key press
    output reg [3:0] key4        // Output for fourth key press
);

    // Wire to hold the debounced row signals
    wire [3:0] row_debounced;

    // Instantiate the debouncer for each row (row_raw are the raw inputs from keypad)
    Keypad_Debouncer debounce0 (
        .clk1KHz(clk1KHz),
        .reset(reset),
        .key_raw(row[0]),
        .key_debounced(row_debounced[0])
    );

    Keypad_Debouncer debounce1 (
        .clk1KHz(clk1KHz),
        .reset(reset),
        .key_raw(row[1]),
        .key_debounced(row_debounced[1])
    );

    Keypad_Debouncer debounce2 (
        .clk1KHz(clk1KHz),
        .reset(reset),
        .key_raw(row[2]),
        .key_debounced(row_debounced[2])
    );

    Keypad_Debouncer debounce3 (
        .clk1KHz(clk1KHz),
        .reset(reset),
        .key_raw(row[3]),
        .key_debounced(row_debounced[3])
    );

    // State machine or scanning logic to handle keypad inputs
    reg [1:0] current_state, next_state;

    always @(posedge clk1KHz or posedge reset) begin
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
    always @(posedge clk1KHz) begin
        case (current_state)
            2'b00: key1 = (row_debounced[0]) ? 4'b0001 : 4'b0000; // Key 1 if debounced row 0 is pressed
            2'b01: key2 = (row_debounced[1]) ? 4'b0010 : 4'b0000; // Key 2 if debounced row 1 is pressed
            2'b10: key3 = (row_debounced[2]) ? 4'b0100 : 4'b0000; // Key 3 if debounced row 2 is pressed
            2'b11: key4 = (row_debounced[3]) ? 4'b1000 : 4'b0000; // Key 4 if debounced row 3 is pressed
            default: begin
                key1 = 4'b0000;
                key2 = 4'b0000;
                key3 = 4'b0000;
                key4 = 4'b0000;
            end
        endcase
    end

    // Storing logic for each key
    reg [3:0] stored_key1, stored_key2, stored_key3, stored_key4;
    reg [1:0] key_index;

    always @(posedge clk1KHz or posedge reset) begin
        if (reset) begin
            stored_key1 <= 4'b0000;
            stored_key2 <= 4'b0000;
            stored_key3 <= 4'b0000;
            stored_key4 <= 4'b0000;
            key_index <= 2'b00; // Reset to start storing from key1
        end else begin
            // Logic to store the keys in different outputs
            if (key_index == 2'b00 && key1 != 4'b0000) begin
                stored_key1 <= key1;
                key_index <= key_index + 1;
            end else if (key_index == 2'b01 && key2 != 4'b0000) begin
                stored_key2 <= key2;
                key_index <= key_index + 1;
            end else if (key_index == 2'b10 && key3 != 4'b0000) begin
                stored_key3 <= key3;
                key_index <= key_index + 1;
            end else if (key_index == 2'b11 && key4 != 4'b0000) begin
                stored_key4 <= key4;
                key_index <= key_index + 1;
            end
        end
    end

    // Assign final outputs (stored keys)
    always @(posedge clk1KHz) begin
        key1 = stored_key1;
        key2 = stored_key2;
        key3 = stored_key3;
        key4 = stored_key4;
    end

endmodule
