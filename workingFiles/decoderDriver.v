`timescale 10ns / 1ns

module decoderDriver(
    input wire clk_100MHz,
    input wire [3:0] row,                      // 4 buttons per row
    input wire resetCount,                    // Reset signal for input counter
    output wire [3:0] col,                 // 4 columns on keypad

    output reg [3:0] userNameInput0,      // Username digit 0
    output reg [3:0] userNameInput1,      // Username digit 1
    output reg [3:0] userNameInput2,      // Username digit 2
    output reg [3:0] userNameInput3,      // Username digit 3
    output reg [3:0] passwordInput0,      // Password digit 0
    output reg [3:0] passwordInput1,      // Password digit 1
    output reg [3:0] passwordInput2,      // Password digit 2
    output reg [3:0] passwordInput3,      // Password digit 3
    output wire [7:0] inputCount           // Count of inputs entered
    );

    wire [3:0] dec_out;

    decoder myDecoder(
        .clk_100MHz(clk_100MHz),
        .resetCount(resetCount),
        .row(row),
        .col(col),
        .dec_out(dec_out),
        .press_count(inputCount)
    );
    
    always @(posedge clk_100MHz)
        begin
            case (inputCount)
                4'd0: userNameInput0 <= dec_out;
                4'd1: userNameInput1 <= dec_out;
                4'd2: userNameInput2 <= dec_out;
                4'd3: userNameInput3 <= dec_out;
                4'd4: passwordInput0 <= dec_out;
                4'd5: passwordInput1 <= dec_out;
                4'd6: passwordInput2 <= dec_out;
                4'd7: passwordInput3 <= dec_out;
                default: ; // Do nothing if more than 8 inputs
            endcase
        end

endmodule