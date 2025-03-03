module tb_Tone_Generator_AMP2_Interface;

    // Inputs
    reg clk;
    reg reset;
    reg password_unlocked;
    reg correct_password;
    reg incorrect_password;

    // Outputs
    wire audio_signal;  // PWM signal from Tone Generator
    wire audio_out;     // Audio output to PmodAMP2

    // Clock generation (50 MHz clock for the Basys3)
    always begin
        #10 clk = ~clk;  // Generate a clock with 50 MHz frequency (20ns period)
    end

    // Instantiate the modules to be tested
    Tone_Generator tone_gen (
        .clk(clk),
        .reset(reset),
        .password_unlocked(password_unlocked),
        .correct_password(correct_password),
        .incorrect_password(incorrect_password),
        .audio_signal(audio_signal)  // PWM audio signal
    );

    PmodAMP2_Interface amp2_interface (
        .clk(clk),
        .reset(reset),
        .audio_signal(audio_signal),
        .audio_out(audio_out)  // Output to PmodAMP2
    );

    // Initial block for testbench stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        password_unlocked = 0;
        correct_password = 0;
        incorrect_password = 0;

        // Apply reset
        reset = 1;
        #100;
        reset = 0;
        
        // Test 1: Simulate password unlocked state (Play first tone for unlock)
        password_unlocked = 1;
        #500;  // Wait for some time to observe the PWM signal
        password_unlocked = 0;

        // Test 2: Simulate correct password state (Play first tone for correct password)
        correct_password = 1;
        #500;  // Wait for some time to observe the PWM signal
        correct_password = 0;

        // Test 3: Simulate incorrect password state (Play first tone for incorrect password)
        incorrect_password = 1;
        #500;  // Wait for some time to observe the PWM signal
        incorrect_password = 0;

        // Test complete
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t, audio_signal = %b, audio_out = %b", $time, audio_signal, audio_out);
    end

    // Dump waveform for simulation
    initial begin
        $dumpfile("tone_generator_amp2.vcd");  // Specify VCD file for waveform
        $dumpvars(0, tb_Tone_Generator_AMP2_Interface);  // Dump all signals
    end

endmodule
