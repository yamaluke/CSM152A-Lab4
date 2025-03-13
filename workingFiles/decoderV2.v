`timescale 10ns / 1ns

module decoder(
    input clk_100MHz,
    input [3:0] row,                      // 4 buttons per row
    input resetCount,                    // Reset signal for input counter
    output reg [3:0] col,                 // 4 columns on keypad

    output reg [3:0] userNameInput0,      // Username digit 0
    output reg [3:0] userNameInput1,      // Username digit 1
    output reg [3:0] userNameInput2,      // Username digit 2
    output reg [3:0] userNameInput3,      // Username digit 3
    output reg [3:0] passwordInput0,      // Password digit 0
    output reg [3:0] passwordInput1,      // Password digit 1
    output reg [3:0] passwordInput2,      // Password digit 2
    output reg [3:0] passwordInput3,      // Password digit 3
    output reg [3:0] inputCount           // Count of inputs entered
    );

    reg [3:0] dec_out;
    parameter LAG = 10;                   // 100MHz / 10 = 10M -> 1/10M = 100ns

    reg [3:0] prev_dec_out = 0;

	reg [19:0] scan_timer = 0;            // to count up to 99,999
	reg [1:0] col_select = 0;             // 2 bit counter to select 4 columns
	
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
					   if(scan_timer == LAG)
						  case(row)
						      4'b0111 :	dec_out <= 4'b0001;	// 1
						      4'b1011 :	dec_out <= 4'b0100;	// 4
						      4'b1101 :	dec_out <= 4'b0111;	// 7
						      4'b1110 :	dec_out <= 4'b0000;	// 0
						  endcase
					end
			2'b01 :	begin
					   col = 4'b1011;
					   if(scan_timer == LAG)
						  case(row)    		
						      4'b0111 :	dec_out <= 4'b0010;	// 2	
						      4'b1011 :	dec_out <= 4'b0101;	// 5	
						      4'b1101 :	dec_out <= 4'b1000;	// 8	
						      4'b1110 : dec_out <= 4'b1111;	// F
			              endcase
			        end 
			2'b10 :	begin       
					   col = 4'b1101;
					   if(scan_timer == LAG)
						  case(row)    		       
						      4'b0111 :	dec_out <= 4'b0011;	// 3 		
						      4'b1011 :	dec_out <= 4'b0110;	// 6 		
						      4'b1101 :	dec_out <= 4'b1001;	// 9 		
						      4'b1110 : dec_out <= 4'b1110;	// E	    
						  endcase      
					end
			2'b11 :	begin
					   col = 4'b1110;
					   if(scan_timer == LAG)
						  case(row)    
						      4'b0111 :	dec_out <= 4'b1010;	// A
						      4'b1011 :	dec_out <= 4'b1011;	// B
						      4'b1101 :	dec_out <= 4'b1100;	// C
						      4'b1110 :	dec_out <= 4'b1101;	// D
						  endcase      
					end
		endcase

    always @(posedge clk_100MHz)
        begin
            if (resetCount) begin
                inputCount <= 0;
                dec_out <= 0;
            end
            else if(dec_out != prev_dec_out) begin
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
                inputCount <= inputCount + 1;
            end

            prev_dec_out <= dec_out;
        end

endmodule