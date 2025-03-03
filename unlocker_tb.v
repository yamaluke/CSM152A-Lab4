module unlocker_tb;
    reg clk;
    reg locker;

    reg [3:0] inputCount;

    reg [4:0] userNameInput0;
    reg [4:0] userNameInput1;
    reg [4:0] userNameInput2;
    reg [4:0] userNameInput3;

    reg[4:0] passwordInput0;
    reg[4:0] passwordInput1;
    reg[4:0] passwordInput2;
    reg[4:0] passwordInput3;

    wire lock;


    unlocker my_unlock(
        .clk(clk),
        .locker(locker), 
        .inputCount(inputCount), 
        .userNameInput0(userNameInput0), 
        .userNameInput1(userNameInput1), 
        .userNameInput2(userNameInput2), 
        .userNameInput3(userNameInput3), 
        .passwordInput0(passwordInput0), 
        .passwordInput1(passwordInput1), 
        .passwordInput2(passwordInput2), 
        .passwordInput3(passwordInput3), 
        .lock(lock)
        );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, unlocker_tb);

        clk = 0;
        #10;
        
        // incorrect password check
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
        passwordInput1 = 1;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 0;
        inputCount = 8;
        #20;

        // correct password check
        userNameInput0 = 0;
        inputCount = 1;
        #1;
        userNameInput1 = 0;
        inputCount = 2;
        #1;
        userNameInput2 = 0;
        inputCount = 3;
        #1;
        userNameInput3 = 0;
        inputCount = 4;
        
        #1;
        passwordInput0 = 0;
        inputCount = 5;
        #1;
        passwordInput1 = 0;
        inputCount = 6;
        #1;
        passwordInput2 = 0;
        inputCount = 7;
        #1;
        passwordInput3 = 0;
        inputCount = 8;
        #20;

        #20 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end
endmodule