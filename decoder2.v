`timescale 1ns / 1ps

module decoder(
    input clk_100MHz,
    input [3:0] row,                      // 4 buttons per row
    output reg [3:0] col,                 // 4 columns on keypad
    output reg [3:0] dec_out,             // binary value of button press
    output reg [3:0] key1,                // Register for the first key press
    output reg [3:0] key2,                // Register for the second key press
    output reg [3:0] key3,                // Register for the third key press
    output reg [3:0] key4                 // Register for the fourth key press
    );

    parameter LAG = 10;                   // 100MHz / 10 = 10M -> 1/10M = 100ns

    reg [19:0] scan_timer = 0;            // to count up to 99,999
    reg [1:0] col_select = 0;             // 2 bit counter to select 4 columns
    reg [3:0] input_counter = 0;          // Counter to track how many digits have been inputted

    // scan timer/column select control
    always @(posedge clk_100MHz)          // 1ms = 1/1000s
    if(scan_timer == 99_999) begin    // 100MHz / 100,000 = 1000
        scan_timer <= 0;
        col_select <= col_select + 1;
    end
    else
        scan_timer <= scan_timer + 1;

    // set columns, check rows
    always @(posedge clk_100MHz) begin
        case(col_select)
            2'b00 : begin
                col = 4'b0111;
                if(scan_timer == LAG)
                    case(row)
                        4'b0111 : dec_out = 4'b0001;  // 1
                        4'b1011 : dec_out = 4'b0100;  // 4
                        4'b1101 : dec_out = 4'b0111;  // 7
                        4'b1110 : dec_out = 4'b0000;  // 0
                    endcase
            end
            2'b01 : begin
                col = 4'b1011;
                if(scan_timer == LAG)
                    case(row)
                        4'b0111 : dec_out = 4'b0010;  // 2    
                        4'b1011 : dec_out = 4'b0101;  // 5    
                        4'b1101 : dec_out = 4'b1000;  // 8    
                        4'b1110 : dec_out = 4'b1111;  // F
                    endcase
            end 
            2'b10 : begin       
                col = 4'b1101;
                if(scan_timer == LAG)
                    case(row)                   
                        4'b0111 : dec_out = 4'b0011;  // 3         
                        4'b1011 : dec_out = 4'b0110;  // 6         
                        4'b1101 : dec_out = 4'b1001;  // 9         
                        4'b1110 : dec_out = 4'b1110;  // E        
                    endcase      
            end
            2'b11 : begin
                col = 4'b1110;
                if(scan_timer == LAG)
                    case(row)    
                        4'b0111 : dec_out = 4'b1010;  // A
                        4'b1011 : dec_out = 4'b1011;  // B
                        4'b1101 : dec_out = 4'b1100;  // C
                        4'b1110 : dec_out = 4'b1101;  // D
                    endcase      
            end
        endcase
    end

    // Store the pressed key in separate registers and track input
    always @(posedge clk_100MHz) begin
        if(scan_timer == LAG && input_counter < 4) begin
            case(input_counter)
                0: key1 <= dec_out;   // Store first key press in key1
                1: key2 <= dec_out;   // Store second key press in key2
                2: key3 <= dec_out;   // Store third key press in key3
                3: key4 <= dec_out;   // Store fourth key press in key4
            endcase
            
            // Increment the input counter for next key press
            input_counter <= input_counter + 1;
        end
    end

    // Optional: Reset the input counter after 4 digits are entered (clear counter)
    always @(posedge clk_100MHz) begin
        if (input_counter == 4) begin
            // Reset the counter after 4 digits entered
            input_counter <= 0;
        end
    end

endmodule
