'timescale 10ns / 1ns

module decoder(
    input clk,
    input [3:0] row,                      // 4 buttons per row
    output reg [3:0] col,                 // 4 columns on keypad
    output reg [3:0] key1,                // 1st key press
    output reg [3:0] key2,                // 2nd key press
    output reg [3:0] key3,                // 3rd key press
    output reg [3:0] key4,                // 4th key press
    output reg input_done                 // Flag to indicate 4 keys pressed
    );

    parameter LAG = 10;                   // 100MHz / 10 = 10M -> 1/10M = 100ns

    reg [19:0] scan_timer = 0;            // to count up to 99,999
    reg [1:0] col_select = 0;             // 2 bit counter to select 4 columns
    reg [3:0] key_count = 0;              // Count the number of keys pressed

    // scan timer/column select control
    always @(posedge clk_100MHz)          // 1ms = 1/1000s
        if(scan_timer == 99_999) begin    // 100MHz / 100,000 = 1000
            scan_timer <= 0;
            col_select <= col_select + 1;
        end
        else
            scan_timer <= scan_timer + 1;

    // set columns, check rows
    always @(posedge clk_100MHz)
    case(col_select)
        2'b00 :	begin
                   col = 4'b0111;
                   if(scan_timer == LAG) begin
                       // Checking row 0
                       case(row)
                           4'b0111 : if (key_count < 4) begin key1 = 4'b0001; key_count = key_count + 1; end // 1
                           4'b1011 : if (key_count < 4) begin key2 = 4'b0100; key_count = key_count + 1; end // 4
                           4'b1101 : if (key_count < 4) begin key3 = 4'b0111; key_count = key_count + 1; end // 7
                           4'b1110 : if (key_count < 4) begin key4 = 4'b0000; key_count = key_count + 1; end // 0
                       endcase
                   end
               end
        2'b01 :	begin
                   col = 4'b1011;
                   if(scan_timer == LAG) begin
                       // Checking row 1
                       case(row)    		
                           4'b0111 : if (key_count < 4) begin key1 = 4'b0010; key_count = key_count + 1; end // 2	
                           4'b1011 : if (key_count < 4) begin key2 = 4'b0101; key_count = key_count + 1; end // 5	
                           4'b1101 : if (key_count < 4) begin key3 = 4'b1000; key_count = key_count + 1; end // 8	
                           4'b1110 : if (key_count < 4) begin key4 = 4'b1111; key_count = key_count + 1; end // F
                       endcase
                   end
               end 
        2'b10 :	begin       
                   col = 4'b1101;
                   if(scan_timer == LAG) begin
                       // Checking row 2
                       case(row)    		       
                           4'b0111 : if (key_count < 4) begin key1 = 4'b0011; key_count = key_count + 1; end // 3 		
                           4'b1011 : if (key_count < 4) begin key2 = 4'b0110; key_count = key_count + 1; end // 6 		
                           4'b1101 : if (key_count < 4) begin key3 = 4'b1001; key_count = key_count + 1; end // 9 		
                           4'b1110 : if (key_count < 4) begin key4 = 4'b1110; key_count = key_count + 1; end // E	    
                       endcase
                   end
               end
        2'b11 :	begin
                   col = 4'b1110;
                   if(scan_timer == LAG) begin
                       // Checking row 3
                       case(row)    
                           4'b0111 : if (key_count < 4) begin key1 = 4'b1010; key_count = key_count + 1; end // A
                           4'b1011 : if (key_count < 4) begin key2 = 4'b1011; key_count = key_count + 1; end // B
                           4'b1101 : if (key_count < 4) begin key3 = 4'b1100; key_count = key_count + 1; end // C
                           4'b1110 : if (key_count < 4) begin key4 = 4'b1101; key_count = key_count + 1; end // D
                       endcase
                   end
               end
    endcase

    // Set input_done flag once all 4 keys have been pressed
    always @(posedge clk_100MHz) begin
        if (key_count == 4) begin
            input_done <= 1'b1;  // All keys pressed
        end
    end

endmodule
