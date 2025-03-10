`timescale 10ns / 1ns

module Keypad (
    input wire clk1KHz,              // Clock input
    input wire reset,                // Reset input
    input wire [3:0] row,            // Raw row inputs from the keypad
    output reg [3:0] col,            // Column outputs to the keypad
    output reg [3:0] key1,           // Output for first key press
    output reg [3:0] key2,           // Output for second key press
    output reg [3:0] key3,           // Output for third key press
    output reg [3:0] key4,           // Output for fourth key press
    output reg input_done           // Signal indicating that 4 keys have been pressed
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

    // Variables to track key presses
    reg [3:0] key_count;  // Counter for key presses
    reg [3:0] col_next;   // Next column state for column multiplexing

    // Detect key presses and column scanning logic
    always @(posedge clk1KHz or posedge reset) begin
        if (reset) begin
            col <= 4'b1110;  // Initial state, first column enabled
            key1 <= 4'b0000;
            key2 <= 4'b0000;
            key3 <= 4'b0000;
            key4 <= 4'b0000;
            key_count <= 4'b0000;  // Reset the key press count
            input_done <= 1'b0;    // Input is not done
        end else begin
            // Column multiplexing (shift through columns)
            col <= col_next;

            // Detect key presses based on the debounced row signals and current column state
            case (col)
                4'b1110: begin
                    if (row_debounced[0] && key_count < 4) key1 <= 4'b0001; // Key 1
                    else if (row_debounced[1] && key_count < 4) key2 <= 4'b0010; // Key 2
                    else if (row_debounced[2] && key_count < 4) key3 <= 4'b0100; // Key 3
                    else if (row_debounced[3] && key_count < 4) key4 <= 4'b1000; // Key A
                end
                4'b1101: begin
                    if (row_debounced[0] && key_count < 4) key1 <= 4'b0101; // Key 4
                    else if (row_debounced[1] && key_count < 4) key2 <= 4'b0110; // Key 5
                    else if (row_debounced[2] && key_count < 4) key3 <= 4'b0111; // Key 6
                    else if (row_debounced[3] && key_count < 4) key4 <= 4'b1011; // Key B
                end
                4'b1011: begin
                    if (row_debounced[0] && key_count < 4) key1 <= 4'b1001; // Key 7
                    else if (row_debounced[1] && key_count < 4) key2 <= 4'b1010; // Key 8
                    else if (row_debounced[2] && key_count < 4) key3 <= 4'b1011; // Key 9
                    else if (row_debounced[3] && key_count < 4) key4 <= 4'b1101; // Key C
                end
                4'b0111: begin
                    if (row_debounced[0] && key_count < 4) key1 <= 4'b1110; // Key 0
                    else if (row_debounced[1] && key_count < 4) key2 <= 4'b1111; // Key F
                    else if (row_debounced[2] && key_count < 4) key3 <= 4'b1100; // Key E
                    else if (row_debounced[3] && key_count < 4) key4 <= 4'b1011; // Key D
                end
                default: begin
                    key1 <= 4'b0000;
                    key2 <= 4'b0000;
                    key3 <= 4'b0000;
                    key4 <= 4'b0000;
                end
            endcase

            // Logic to count the key presses and limit to 4 key presses
            if (key_count < 4) begin
                if (row_debounced[0] || row_debounced[1] || row_debounced[2] || row_debounced[3]) begin
                    key_count <= key_count + 1;
                end
            end

            // Once 4 keys are pressed, set the input_done flag
            if (key_count == 4) begin
                input_done <= 1'b1;  // Indicate that input is complete
            end
        end
    end

    // Column Multiplexing Logic: Update next column based on the current column state
    always @(*) begin
        case (col)
            4'b1110: col_next = 4'b1101;  // Shift to column 1
            4'b1101: col_next = 4'b1011;  // Shift to column 2
            4'b1011: col_next = 4'b0111;  // Shift to column 3
            4'b0111: col_next = 4'b1110;  // Shift back to column 0
            default: col_next = 4'b1110;  // Default to column 0 if error occurs
        endcase
    end

endmodule
