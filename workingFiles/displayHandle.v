module displayHandle(
    input wire clk, // 1hz
    input wire clk1KHz, //1khz
    input wire flag,
    input wire flagSelect,
    input wire lock,

    output reg flagResolve,
    output reg locker,

    output wire [3:0] seg,     // 7-segment display output
    output wire [3:0] an,       // 4-digit select output (anode control)

    output wire seg2,
    output wire an2
    );

    reg prevLockState;

    reg countDownActive;
    wire [3:0] s10;
    wire [3:0] s1;

    reg smallDisplay10;
    reg smallDisplay1;

    display my_Display(
        .clk1KHz(clk1KHz),
        .digit1(4'b0000),  // Digit 1 input
        .digit2(4'b0000),  // Digit 2 input
        .digit3(s10),  // Digit 3 input
        .digit4(s1),  // Digit 4 input 
        .seg(seg),     // 7-segment display output
        .an(an)       // 4-digit select output (anode control)
    );

    /*
    display2 my_display2(
        .clk1KHz(clk1KHz),
        .digit1(smallDisplay10),  // Digit 1 input (1 bit)
        .digit2(smallDisplay1),  // Digit 2 input (1 bit)
        .seg(seg2),     // 7-segment display output
        .an(an2)       // 4-digit select output (anode control)
    );
    */

    countDown my_CountDown(
        .clk(clk), // 1hz
        .countDownActive(countDownActive),

        .s10(s10),
        .s1(s1)
    );

    initial 
    begin
        flagResolve <= 0;
        countDownActive <= 0;
        locker <= 0;
        smallDisplay10 <= 1;
        smallDisplay1 <= 1;
        prevLockState <= 1;
    end

    always @(posedge clk) 
    begin
        prevLockState <= lock;
       if(flag && ~flagSelect)
       begin
            // wrong password 
            smallDisplay10 <= 0;
            smallDisplay1 <= 0;

            flagResolve <= 1;
       end
       else if(flag && flagSelect && ~flagResolve)
       begin
            // 3 failed attempts 
            if(~countDownActive)
            begin
                countDownActive <= 1;
                smallDisplay10 <= 0;
                smallDisplay1 <= 0;
                $display("Count down activated");
            end
            else if(s10 == 0 && s1 == 0)
            begin   
                smallDisplay10 <= 1;
                smallDisplay1 <= 1;
                flagResolve <= 1;
                countDownActive <= 0;
            end
       end
       else
       begin
            flagResolve <= 0;
       end

       if (~lock && ~locker) begin
            if(~countDownActive)
            begin
                smallDisplay10 <= 0;
                smallDisplay1 <= 1;
                countDownActive <= 1;
            end
            else if(s10 == 0 && s1 == 0)
            begin   
                locker <= 1;
                smallDisplay10 <= 1;
                smallDisplay1 <= 1;
                countDownActive <= 0;
            end
       end
       else if(~prevLockState && lock)
       begin
            smallDisplay10 <= 1;
            smallDisplay1 <= 1;
       end
       else
        begin
            locker <= 0;
        end
    end



endmodule