module mainDriver_tb;
    reg clk;

    reg btn1;
    reg btn2;
    reg btn3;
    reg btn4;
    reg btn5;

    reg switch1;

    reg [3:0] inputCount;

    reg [3:0] userNameInput0;
    reg [3:0] userNameInput1;
    reg [3:0] userNameInput2;
    reg [3:0] userNameInput3;

    reg[3:0] passwordInput0;
    reg[3:0] passwordInput1;
    reg[3:0] passwordInput2;
    reg[3:0] passwordInput3;

    
    wire resetCount;

    wire [3:0] seg;     // 7-segment display output
    wire [3:0] an;       // 4-digit select output (anode control)

    wire [3:0] seg2;
    wire an2;

    reg[3:0] checkCount;

    unlocker my_unlock(
        .clk(clk),
        .locker(locker), 
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .btn4(btn4),
        .btn5(btn5),
        .switch1(switch1),
        .inputCount(inputCount), 
        .userNameInput0(userNameInput0), 
        .userNameInput1(userNameInput1), 
        .userNameInput2(userNameInput2), 
        .userNameInput3(userNameInput3), 
        .passwordInput0(passwordInput0), 
        .passwordInput1(passwordInput1), 
        .passwordInput2(passwordInput2), 
        .passwordInput3(passwordInput3), 
        .flagResolve(flagResolve),
        .lock(lock),
        .flag(flag),
        .flagSelect(flagSelect),
        .resetCount(resetCount)
    );

    displayHandle myDisplayHandle(
        .clk(clk),
        .clk1KHz(clk),
        .flag(flag),
        .flagSelect(flagSelect),
        .lock(lock),

        .flagResolve(flagResolve),
        .locker(locker),
        .seg(seg),     // 7-segment display output
        .an(an),        // 4-digit select output
        .seg2(seg2),
        .an2(an2)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, mainDriver_tb);
        $display("Waveform created");

        clk = 0;
        checkCount = 1;
        //== incorrect password check ==//
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 1;
        inputCount = 3;
        #1;
        userNameInput3 = 1;
        inputCount = 4;
        
        #1;
        passwordInput0 = 1;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;

        checkCount = 2;
        //== lockout check ==//
        //incorrect 1
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 1;
        inputCount = 3;
        #1;
        userNameInput3 = 1;
        inputCount = 4;
        
        #1;
        passwordInput0 = 1;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;

        //incorrect 2
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 1;
        inputCount = 3;
        #1;
        userNameInput3 = 1;
        inputCount = 4;
        
        #1;
        passwordInput0 = 1;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;

        //incorrect 3
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 1;
        inputCount = 3;
        #1;
        userNameInput3 = 1;
        inputCount = 4;
        
        #1;
        passwordInput0 = 1;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;
        inputCount = 0;

        checkCount = checkCount + 1;
        //==check to see if use is locked out, should keep user locked out
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 1;
        inputCount = 3;
        #1;
        userNameInput3 = 1;
        inputCount = 4;
        
        #1;
        passwordInput0 = 0;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;
        inputCount = 0;

        checkCount = checkCount + 1;
        //==log in after, and start count down for auto lock
        #150;
        inputCount = 8;
        #2;
        inputCount = 0;
        #150;
        


        #15 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end
endmodule