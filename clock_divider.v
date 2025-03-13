`timescale 10ns / 1ns

module clock_divider(
    input wire clk, // 100 MHz
    output reg clk1Hz,
    output reg clk2Hz,
    output reg clk5Hz,
    output reg clk1KHz
    );
    
    reg [31:0] count1Hz;
    reg [31:0] count2Hz;
    reg [31:0] count5HZ;
    reg [31:0] count1KHz;
    
    always@(posedge clk)
    begin
        if (count1KHz == 50000)
        begin
            clk1KHz <= ~clk1KHz;
            count1KHz <= 0;
        end
        else
        begin
            count1KHz <= count1KHz + 1;
        end
        
        if (count5HZ == 10000000)
        begin
            clk5Hz <= ~clk5Hz;
            count5HZ <= 0;
        end
        else
        begin
            count5HZ <= count5HZ + 1;
        end
        
        if (count2Hz == 25000000)
        begin
            clk2Hz <= ~clk2Hz;
            count2Hz <= 0;
        end
        else
        begin
            count2Hz <= count2Hz + 1;
        end
        
        if (count1Hz == 50000000)
        begin
            clk1Hz <= ~clk1Hz;
            count1Hz <= 0;
        end
        else
        begin
            count1Hz <= count1Hz + 1;           
        end
    end
    
endmodule