module Tone_Generator (
    input wire clk,               // System clock input (e.g., 100 MHz)
    input wire reset,             // Reset input
    input wire password_unlocked, // Signal for password unlocked
    input wire correct_password,  // Signal for correct password
    input wire incorrect_password, // Signal for incorrect password
    output reg audio_signal       // PWM signal output to PmodAMP2
);

    // Frequency definitions for different notes (in Hz)
    parameter C4_FREQ = 261;      // Frequency for C4 note (261 Hz)
    parameter E4_FREQ = 329;      // Frequency for E4 note (329 Hz)
    parameter A4_FREQ = 440;      // Frequency for A4 note (440 Hz)
    parameter C5_FREQ = 523;      // Frequency for C5 note (523 Hz)
    parameter D4_FREQ = 294;      // Frequency for D4 note (294 Hz)
    parameter F4_FREQ = 349;      // Frequency for F4 note (349 Hz)

    // Counter register for generating PWM signal
    reg [31:0] counter;          // PWM counter
    reg [31:0] max_count;        // Max count for PWM period
    reg [1:0] tone_counter;      // Counter to switch between first and second tone
    reg [2:0] state;             // 3-bit state register
    reg [2:0] prev_state;        // Previous state register to detect state changes
    reg sound_triggered;         // Flag to ensure sound only plays once per state

    // State encoding for different events
    localparam UNLOCKED_STATE = 3'b001;
    localparam CORRECT_STATE = 3'b010;
    localparam INCORRECT_STATE = 3'b100;

    // Set the max counter value based on the selected event
    always @(*) begin
        case (state)
            UNLOCKED_STATE: max_count = 100000000 / C4_FREQ;  // Unlock tone 1
            CORRECT_STATE: max_count = 100000000 / A4_FREQ;  // Correct Password tone 1
            INCORRECT_STATE: max_count = 100000000 / D4_FREQ;  // Incorrect Password tone 1
            default: max_count = 0;
        endcase
    end

    // State machine to switch between different states based on inputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;  // No state
            prev_state <= 3'b000;
            sound_triggered <= 0;  // Ensure sound is not triggered initially
        end else begin
            if (password_unlocked) begin
                state <= UNLOCKED_STATE;  // Password unlocked
            end else if (correct_password) begin
                state <= CORRECT_STATE;   // Correct password entered
            end else if (incorrect_password) begin
                state <= INCORRECT_STATE; // Incorrect password entered
            end
        end
    end

    // Logic to play sound only once per state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            tone_counter <= 0;  // Reset the tone counter
            audio_signal <= 0;  // Reset the PWM signal
            sound_triggered <= 0;  // Ensure sound trigger is reset
        end else begin
            // Only trigger sound once when state changes
            if (state != prev_state && !sound_triggered) begin
                sound_triggered <= 1;  // Mark that the sound is triggered for this state
                counter <= 0;          // Reset counter to start sound
                tone_counter <= 0;     // Start with the first tone
            end

            if (sound_triggered) begin
                if (counter < max_count - 1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    audio_signal <= ~audio_signal;  // Toggle the PWM signal

                    // Switch between the first and second tones for the current state
                    if (tone_counter == 1) begin
                        tone_counter <= 0;  // Reset to play the first tone
                        sound_triggered <= 0;  // Reset flag after both tones are played
                    end else begin
                        tone_counter <= 1;  // Switch to the second tone
                    end
                end
            end
        end
    end

    // Update previous state for the next cycle
    always @(posedge clk) begin
        if (!reset) begin
            prev_state <= state;
        end
    end

endmodule
