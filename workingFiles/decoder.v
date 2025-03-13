`timescale 10ns / 1ns

module decoder(
    input clk_100MHz,
    input resetCount,                    // Reset signal for press_count
    input [3:0] row,                      // 4 buttons per row
    output reg [3:0] col,                 // 4 columns on keypad
    output reg [3:0] dec_out,             // binary value of button press
    output reg [7:0] press_count          // count of button presses
    );

    parameter LAG = 10;                   // 100MHz / 10 = 10M -> 1/10M = 100ns

    reg [19:0] scan_timer = 0;            // to count up to 99,999
    reg [1:0] col_select = 0;             // 2 bit counter to select 4 columns
    reg [3:0] last_dec_out = 4'b1111;     // Track the last decoded output to detect changes

    // Initialize press count
    initial begin
        press_count = 8'b11111111;
    end

    // scan timer/column select control
    always @(posedge clk_100MHz)          // 1ms = 1/1000s
        if(scan_timer == 99_999) begin    // 100MHz / 100,000 = 1000
            scan_timer <= 0;
            col_select <= col_select + 1;
        end
        else
            scan_timer <= scan_timer + 1;

    // set columns, check rows, and update press_count
    always @(posedge clk_100MHz) begin
        case(col_select)
            2'b00 :	begin
                       col = 4'b0111;
                       if(scan_timer == LAG)
                          case(row)
                            4'b0111 :	dec_out = 4'b0001;	// 1
                            4'b1011 :	dec_out = 4'b0100;	// 4
                            4'b1101 :	dec_out = 4'b0111;	// 7
                            4'b1110 :	dec_out = 4'b0000;	// 0
                          endcase
                    end
            2'b01 :	begin
                       col = 4'b1011;
                       if(scan_timer == LAG)
                          case(row)    		
                            4'b0111 :	dec_out = 4'b0010;	// 2	
                            4'b1011 :	dec_out = 4'b0101;	// 5	
                            4'b1101 :	dec_out = 4'b1000;	// 8	
                            4'b1110 : dec_out = 4'b1111;	// F
                          endcase
                    end 
            2'b10 :	begin       
                       col = 4'b1101;
                       if(scan_timer == LAG)
                          case(row)    		       
                            4'b0111 :	dec_out = 4'b0011;	// 3 		
                            4'b1011 :	dec_out = 4'b0110;	// 6 		
                            4'b1101 :	dec_out = 4'b1001;	// 9 		
                            4'b1110 : dec_out = 4'b1110;	// E	    
                          endcase      
                    end
            2'b11 :	begin
                       col = 4'b1110;
                       if(scan_timer == LAG)
                          case(row)    
                            4'b0111 :	dec_out = 4'b1010;	// A
                            4'b1011 :	dec_out = 4'b1011;	// B
                            4'b1101 :	dec_out = 4'b1100;	// C
                            4'b1110 :	dec_out = 4'b1101;	// D
                          endcase      
                    end
        endcase
    end

    // Detect button press and update count
    always @(posedge clk_100MHz) begin
        if (resetCount) begin
            press_count <= 0;
        end
        else if (dec_out != 4'b1111 && dec_out != last_dec_out) begin
            // A new button has been pressed (not previously pressed state)
            press_count <= press_count + 1;
        end
        last_dec_out <= dec_out; // Update the last decoded output
    end

endmodule