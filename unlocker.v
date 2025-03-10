module unlocker(
    input wire clk, 
    input wire locker, 

    input wire btn1,
    input wire btn2,
    input wire btn3,
    input wire btn4,
    input wire btn5,
    input wire switch1, // ==0 : guest account // ==1 : user account 

    input wire [3:0] inputCount,
    

    input wire [3:0] userNameInput0,
    input wire [3:0] userNameInput1,
    input wire [3:0] userNameInput2,
    input wire [3:0] userNameInput3,

    input wire[3:0] passwordInput0,
    input wire[3:0] passwordInput1,
    input wire[3:0] passwordInput2,
    input wire[3:0] passwordInput3,

    input wire flagResolve, //indicates that the flag has been delt with 

    output reg lock,
    output reg flag,        //when flag goes up error = incorrect password 
    output reg flagSelect,     //flagSelect = 0: wrong password attempt, flagSelect = 1: 3 incorrect attempts 
    output reg resetCount   //tell other module to reset inputCount to 0, also means input is not going to get read

    );

    reg [15:0] userList [7:0];    // Array of 8 elements, each 20 bits wide
    reg [15:0] userPassword [7:0]; // Array of 8 elements, each 20 bits wide
    reg [1:0] userMode [7:0];      // 0=admin, 1=user, 2=guest

    reg[15:0] tempUser;
    reg[15:0] tempPassword;

    integer userCount;
    
    integer currentUser;

    integer loginAttempts;

    integer i;

    initial 
    begin
        userList[0] <= 16'b0001000100000000;
        userPassword[0] <= 16'b0001000100000000;
        userMode[0] <= 2'b00;
        currentUser <= 0;
        userCount <= 1;
        lock <= 1;
        loginAttempts <= 0;
        lockout <= 0;
    end

    always @(posedge clk) 
    begin
        if(flag && flagResolve)
        begin
            flagSelect <= 0;
            flag <= 0;
        end
        if(~lock)
        begin
            if(locker || btn1)
            begin
                if(userMode[currentUser] == 2)
                begin
                    // remove current user 
                    userCount <= userCount - 1;
                    userList[currentUser][15:0] <= userList[userCount][15:0];
                    userPassword[currentUser][15:0] <= userPassword[userCount][15:0];
                    userMode[currentUser] <= userMode[userCount];
                end
                lock <= 1;
                resetCount <= 0;
            end
            else if(userMode[currentUser][1:0] == 2'b00 || userMode[currentUser][1:0] == 2'b01)
            begin
                if(btn2)
                begin
                    // reset password
                    resetCount <= 0;
                    if(inputCount == 4)
                    begin
                        userPassword[currentUser][15:0] <= {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]};
                        // $display("New password: %b", userPassword[currentUser][19:0]);
                        resetCount <= 1;
                    end
                    
                    
                end
                else if(userMode[currentUser][1:0] == 2'b00)
                begin
                    if(btn3)
                    begin
                        // add user 
                        resetCount <= 0;
                        if(inputCount == 8)
                        begin
                            if(userCount < 8)
                            begin
                                userList[userCount] <= {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]};
                                userPassword[userCount] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};
                                if(switch1)
                                begin
                                    userMode[userCount] <= 1;
                                end
                                else
                                begin
                                    userMode[userCount] <= 2;
                                end
                                resetCount <= 1;
                                userCount <= userCount + 1;
                            end
                            else
                            begin
                                // alert too many usres
                                // flag <= 1;
                            end
                        end
                    end
                    else if(btn4)
                    begin
                        // change password
                        resetCount <= 0;
                        if(inputCount == 8)
                        begin
                            resetCount <= 1;
                            for(i=0; i<userCount; i=i+1)
                            begin
                                tempUser <= userList[i][15:0];
                                tempPassword <= userPassword[i][15:0];
                                if(tempUser[3:0] == userNameInput0 && tempUser[7:4] == userNameInput1 && tempUser[11:8] == userNameInput2 && tempUser[15:12] == userNameInput3)
                                begin
                                    userPassword[i] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};
                                end
                            end
                        end

                    end
                    else if(btn5)
                    begin
                        // delete user 
                        resetCount <= 0;
                        if(inputCount == 4)
                        begin
                            resetCount <= 1;
                            for(i=0; i<userCount; i=i+1)
                            begin
                                tempUser <= userList[i][15:0];
                                tempPassword <= userPassword[i][15:0];
                                if(tempUser[3:0] == userNameInput0 && tempUser[7:4] == userNameInput1 && tempUser[11:8] == userNameInput2 && tempUser[15:12] == userNameInput3)
                                begin
                                    userCount <= userCount - 1;
                                    userList[i][15:0] <= userList[userCount][15:0];
                                    userPassword[i][15:0] <= userPassword[userCount][15:0];
                                    userMode[i] <= userMode[userCount];
                                end
                            end
                        end
                    end
                end
            end
        end
        else if(inputCount == 8)
        begin
            for(i=0; i<userCount; i=i+1)
            begin
                tempUser <= userList[i][19:0];
                tempPassword <= userPassword[i][19:0];
                if(tempUser[3:0] == userNameInput0 && tempUser[7:4] == userNameInput1 && tempUser[11:8] == userNameInput2 && tempUser[15:12] == userNameInput3)
                begin
                    if(tempPassword[3:0] == passwordInput0 && tempPassword[7:4] == passwordInput1 && tempPassword[11:8] == passwordInput2 && tempPassword[15:12] == passwordInput3)
                    begin
                        currentUser <= i;
                        lock <= 0;
                        resetCount <= 1;
                        loginAttempts <= 0;
                    end
                    else
                    begin
                        loginAttempts <= loginAttempts + 1;
                        flag <= 1;
                        if(loginAttempts == 3)
                        begin
                            flagSelect <= 1;
                            loginAttempts <= 0;
                        end
                        else
                        begin
                            flagSelect <= 0;
                        end
                    end;
                end
            end
        end
        
    end



endmodule