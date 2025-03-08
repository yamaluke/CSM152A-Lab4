module unlocker_tb;
    reg clk;
    reg locker;

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

    reg flagResolve;

    wire lock;
    wire flag;
    wire resetCount;

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
        .resetCount(resetCount)
        );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, unlocker_tb);

        clk = 0;
        #10;
        
        checkCount = 0;
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

        checkCount = 1;
        //== correct password check ==//
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
        #20;

        checkCount = 1;
        //== log out check ==//
        //log out 
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #20;

        // attempt to log back in
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
        #20;

        checkCount = 2;
        //== reset password check ==//
        btn2 = 1;
        inputCount = 0;
        #1;
        userNameInput0 = 2;
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
        #20;
        btn2 = 0;

        // log out 
        btn1 = 1;
        #10
        btn1 = 0;
        #20;

        // attempt old password 
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
        #20;

        // new password 
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
        passwordInput0 = 2;
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
        #20;

        checkCount = 3;
        //== add new user check ==//
        //create account 
        btn3 = 1;
        inputCount = 0;
        #1;

        userNameInput0 = 1;
        inputCount = 1;
        switch1 = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;
        btn3=0;

        //logout 
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #20;
        

        //attempt log in
        userNameInput0 = 1;
        inputCount = 1;
        switch1 = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;

        checkCount = 4;
        //== switch password of other user ==//
        //log into admin account
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #1;
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
        passwordInput0 = 2;
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
        #20;

        //switch password 
        btn4 = 1;
        userNameInput0 = 1;
        inputCount = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 9;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;
        btn4 = 0;

        //check login
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #1;
        //old password 
        userNameInput0 = 1;
        inputCount = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #20;

        //correct password 
        inputCount = 0;
        userNameInput0 = 1;
        inputCount = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 9;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;

        checkCount = 5;
        //==test delete user
        //log into admin account
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #1;
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
        passwordInput0 = 2;
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
        #20;

        //delete last user 
        btn5 = 1;
        inputCount = 0;
        #1;
        userNameInput0 = 1;
        inputCount = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        #5;
        btn5 = 0;

        //create guest account 
        btn3 = 1;
        inputCount = 0;
        #1;

        userNameInput0 = 1;
        inputCount = 1;
        switch1 = 0;
        #1;
        userNameInput1 = 5;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #1;
        btn3=0;

        //attempt log in with deleted uesr
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #1;

        inputCount = 0;
        userNameInput0 = 1;
        inputCount = 1;
        #1;
        userNameInput1 = 2;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 9;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;

        //log into guest account
        inputCount = 0;
        userNameInput0 = 1;
        inputCount = 1;
        switch1 = 0;
        #1;
        userNameInput1 = 5;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;

        //attempt to log in again
        btn1 = 1;
        inputCount = 0;
        #10
        btn1 = 0;
        #5;

        userNameInput0 = 1;
        inputCount = 1;
        switch1 = 0;
        #1;
        userNameInput1 = 5;
        inputCount = 2;
        #1;
        userNameInput2 = 3;
        inputCount = 3;
        #1;
        userNameInput3 = 4;
        inputCount = 4;
        
        #1;
        passwordInput0 = 2;
        inputCount = 5;
        #1;
        passwordInput1 = 7;
        inputCount = 6;
        #1;
        passwordInput2 = 1;
        inputCount = 7;
        #1;
        passwordInput3 = 1;
        inputCount = 8;
        #5;


        #20 $finish;
    end

    always begin
        #0.5 clk = ~clk;
    end
endmodule