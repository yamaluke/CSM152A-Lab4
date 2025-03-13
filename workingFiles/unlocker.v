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

    integer userCount;
    
    integer currentUser;

    integer loginAttempts;

    reg foundMatch;

    integer i;

    initial 
    begin
        userList[1] <= 16'b0000000000000000;
        userPassword[1] <= 16'b0000000000000000;
        userMode[1] <= 2'b00;

        userList[2] <= 16'b0000000000000000;
        userPassword[2] <= 16'b0000000000000000;
        userMode[2] <= 2'b00;

        userList[3] <= 16'b0000000000000000;
        userPassword[3] <= 16'b0000000000000000;
        userMode[3] <= 2'b00;

        userList[4] <= 16'b0000000000000000;
        userPassword[4] <= 16'b0000000000000000;
        userMode[4] <= 2'b00;

        userList[5] <= 16'b0000000000000000;
        userPassword[5] <= 16'b0000000000000000;
        userMode[5] <= 2'b00;

        userList[6] <= 16'b0000000000000000;
        userPassword[6] <= 16'b0000000000000000;
        userMode[6] <= 2'b00;

        userList[7] <= 16'b0000000000000000;
        userPassword[7] <= 16'b0000000000000000;
        userMode[7] <= 2'b00;
        // Add default admin user with username 1234 and password 1234
        
        userList[0] <= 16'b0001001000110100;      // 1234 in binary (4 bits per digit)
        userPassword[0] <= 16'b0001001000110100;   // 1234 in binary (4 bits per digit)
        userMode[0] <= 2'b00;                      // Admin mode
        
        currentUser <= 0;
        userCount <= 1;
        lock <= 1;
        loginAttempts <= 0;
        flag <= 0;
        flagSelect <= 0;
        resetCount <= 0;
    end

    always @(posedge clk) 
    begin
        if(flag)
        begin
            if(flagResolve)
            begin
                flagSelect <= 0;
                flag <= 0;
                resetCount <= 0;
            end
        end
        else if(~lock)
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

                    userList[userCount][15:0] <= 16'b0000000000000000;
                    userPassword[userCount][15:0] <= 16'b0000000000000000;
                    userMode[userCount] <= 2'b00;
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
                    if(inputCount >= 4)
                    begin
                        userPassword[currentUser][15:0] <= {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]};
                        // $display("New password: %b", userPassword[currentUser][15:0]);
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
                                $display("User added %d", userCount);
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
                        
                        if(inputCount == 8)
                        begin
                            $display("Changing password");
                            resetCount <= 1;
                            if(userList[0][3:0] == userNameInput0 && userList[0][7:4] == userNameInput1 && userList[0][11:8] == userNameInput2 && userList[0][15:12] == userNameInput3)
                                userPassword[0] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[1][3:0] == userNameInput0 && userList[1][7:4] == userNameInput1 && userList[1][11:8] == userNameInput2 && userList[1][15:12] == userNameInput3)
                                userPassword[1] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[2][3:0] == userNameInput0 && userList[2][7:4] == userNameInput1 && userList[2][11:8] == userNameInput2 && userList[2][15:12] == userNameInput3)
                                userPassword[2] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[3][3:0] == userNameInput0 && userList[3][7:4] == userNameInput1 && userList[3][11:8] == userNameInput2 && userList[3][15:12] == userNameInput3)
                                userPassword[3] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[4][3:0] == userNameInput0 && userList[4][7:4] == userNameInput1 && userList[4][11:8] == userNameInput2 && userList[4][15:12] == userNameInput3)
                                userPassword[4] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[5][3:0] == userNameInput0 && userList[5][7:4] == userNameInput1 && userList[5][11:8] == userNameInput2 && userList[5][15:12] == userNameInput3)
                                userPassword[5] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[6][3:0] == userNameInput0 && userList[6][7:4] == userNameInput1 && userList[6][11:8] == userNameInput2 && userList[6][15:12] == userNameInput3)
                                userPassword[6] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};

                            if(userList[7][3:0] == userNameInput0 && userList[7][7:4] == userNameInput1 && userList[7][11:8] == userNameInput2 && userList[7][15:12] == userNameInput3)
                                userPassword[7] <= {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]};
                        end
                        else
                        begin
                            $display("Password not changed");
                            resetCount <= 0;
                        end
                        

                    end
                    else if(btn5)
                    begin
                        // delete user 
                        resetCount <= 0;
                        if(inputCount == 4)
                        begin
                            resetCount <= 1;
                            

                            if(userList[0][3:0] == userNameInput0 && userList[0][7:4] == userNameInput1 && userList[0][11:8] == userNameInput2 && userList[0][15:12] == userNameInput3)
                            begin
                                userList[0][15:0] <= userList[userCount-1][15:0];
                                userPassword[0][15:0] <= userPassword[userCount-1][15:0];
                                userMode[0] <= userMode[userCount-1];
                            end
                            else if(userList[1][3:0] == userNameInput0 && userList[1][7:4] == userNameInput1 && userList[1][11:8] == userNameInput2 && userList[1][15:12] == userNameInput3)
                            begin
                                userList[1][15:0] <= userList[userCount-1][15:0];
                                userPassword[1][15:0] <= userPassword[userCount-1][15:0];
                                userMode[1] <= userMode[userCount-1];
                            end
                            else if(userList[2][3:0] == userNameInput0 && userList[2][7:4] == userNameInput1 && userList[2][11:8] == userNameInput2 && userList[2][15:12] == userNameInput3)
                            begin
                                userList[2][15:0] <= userList[userCount-1][15:0];
                                userPassword[2][15:0] <= userPassword[userCount-1][15:0];
                                userMode[2] <= userMode[userCount-1];
                            end
                            else if(userList[3][3:0] == userNameInput0 && userList[3][7:4] == userNameInput1 && userList[3][11:8] == userNameInput2 && userList[3][15:12] == userNameInput3)
                            begin
                                userList[3][15:0] <= userList[userCount-1][15:0];
                                userPassword[3][15:0] <= userPassword[userCount-1][15:0];
                                userMode[3] <= userMode[userCount-1];
                            end
                            else if(userList[4][3:0] == userNameInput0 && userList[4][7:4] == userNameInput1 && userList[4][11:8] == userNameInput2 && userList[4][15:12] == userNameInput3)
                            begin
                                userList[4][15:0] <= userList[userCount-1][15:0];
                                userPassword[4][15:0] <= userPassword[userCount-1][15:0];
                                userMode[4] <= userMode[userCount-1];
                            end
                            else if(userList[5][3:0] == userNameInput0 && userList[5][7:4] == userNameInput1 && userList[5][11:8] == userNameInput2 && userList[5][15:12] == userNameInput3)
                            begin
                                userList[5][15:0] <= userList[userCount-1][15:0];
                                userPassword[5][15:0] <= userPassword[userCount-1][15:0];
                                userMode[5] <= userMode[userCount-1];
                            end
                            else if(userList[6][3:0] == userNameInput0 && userList[6][7:4] == userNameInput1 && userList[6][11:8] == userNameInput2 && userList[6][15:12] == userNameInput3)
                            begin
                                userList[6][15:0] <= userList[userCount-1][15:0];
                                userPassword[6][15:0] <= userPassword[userCount-1][15:0];
                                userMode[6] <= userMode[userCount-1];
                            end
                            else if(userList[7][3:0] == userNameInput0 && userList[7][7:4] == userNameInput1 && userList[7][11:8] == userNameInput2 && userList[7][15:12] == userNameInput3)
                            begin
                                userList[7][15:0] <= userList[userCount-1][15:0];
                                userPassword[7][15:0] <= userPassword[userCount-1][15:0];
                                userMode[7] <= userMode[userCount-1];
                            end
                            userCount <= userCount - 1;
                            userList[userCount][15:0] <= 16'b0000000000000000;
                            userPassword[userCount][15:0] <= 16'b0000000000000000;
                            userMode[userCount] <= 2'b00;
                        end
                    end
                end
            end
        end
        else if(inputCount == 8)
        begin
            resetCount <= 1;
            // Default to unsuccessful login
            foundMatch = 0;
            
            // Check each user in parallel (synthesis will create parallel comparators)
            if(userList[0][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
               userPassword[0][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 0;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[1][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[1][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 1;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[2][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[2][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 2;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[3][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[3][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 3;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[4][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[4][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 4;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[5][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[5][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin   
                currentUser <= 5;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end
            else if(userList[6][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[6][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 6;
                lock <= 0;
                loginAttempts <= 0;
                foundMatch = 1;
                $display("Match found");
            end 
            else if(userList[7][15:0] == {userNameInput3[3:0], userNameInput2[3:0], userNameInput1[3:0], userNameInput0[3:0]} &&
                    userPassword[7][15:0] == {passwordInput3[3:0], passwordInput2[3:0], passwordInput1[3:0], passwordInput0[3:0]})
            begin
                currentUser <= 7;
                lock <= 0;
                loginAttempts <= 0; 
                foundMatch = 1;
                $display("Match found");
            end

            // If no match was found
            if(!foundMatch)
            begin
                $display("No match found");
                flag <= 1;
                if(loginAttempts == 2)
                begin
                    flagSelect <= 1;
                    loginAttempts <= 0;
                end
                else
                begin
                    loginAttempts <= loginAttempts + 1;
                    flagSelect <= 0;
                end
            end
        end
        
    end



endmodule