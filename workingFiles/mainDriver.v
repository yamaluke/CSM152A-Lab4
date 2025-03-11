module mainDriver(
    input wire clk, // 100 mhz
    input wire btn1,
    input wire btn2,
    input wire btn3,
    input wire btn4,
    input wire btn5,
    input wire switch1, // ==0 : guest account // ==1 : user account 

    //take in input for the keypad 

    output wire [3:0] seg,     // 7-segment display output
    output wire [3:0] an,       // 4-digit select output (anode control)

    output wire seg2,
    output wire an2
    );

    wire locker;
    wire lock;
    wire flag;
    wire flagSelect;

    wire clk1Hz;
    wire clk2Hz;
    wire clk5Hz;
    wire clk1KHz;

    wire [3:0] userNameInput0;
    wire [3:0] userNameInput1;
    wire [3:0] userNameInput2;
    wire [3:0] userNameInput3;

    wire[3:0] passwordInput0;
    wire[3:0] passwordInput1;
    wire[3:0] passwordInput2;
    wire[3:0] passwordInput3;

    wire [3:0] inputCount;
    wire resetCount;

    clock_divider my_clock_divider(
        .clk(clk), // 100 MHz
        .clk1Hz(clk1Hz),
        .clk2Hz(clk2Hz),
        .clk5Hz(clk5Hz),
        .clk1KHz(clk1KHz)
    );

    unlocker my_unlock(
        .clk(clk1Hz),
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
        .clk(clk1Hz),
        .clk1KHz(clk1KHz),
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

    /* inside the keypad module 
    // module should also set values to the input username and password variables 
    if(resetCount)
    begin
        inputCount <= 0;
    end
    */


endmodule