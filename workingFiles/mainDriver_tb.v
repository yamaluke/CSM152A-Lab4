module mainDriver_tb;
    reg clk; // 100 mhz
    reg btn1;    // unlock button
    reg switch1; // ==0 : guest account // ==1 : user account 
    reg switch2;    // reset switch
    reg switch3;    
    reg switch4;
    reg switch5;

    //take in input needed for the keypad 
    reg [3:0] row;
    wire [3:0] col;

    wire [6:0] seg;     // 7-segment display output
    wire [3:0] an;       // 4-digit select output (anode control)

    wire [6:0] seg2;
    wire an2;

    reg [3:0] checkCount;

    mainDriver my_mainDriver(
        .clk(clk),
        .btn1(btn1),
        .switch1(switch1),
        .switch2(switch2),
        .switch3(switch3),
        .switch4(switch4),
        .switch5(switch5),
        .row(row),
        .col(col),
        .seg(seg),
        .an(an),
        .seg2(seg2),
        .an2(an2)
    );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, mainDriver_tb);
        $display("Waveform created");

        
        #150;
        


        #15 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end
endmodule