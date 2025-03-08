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
    

    input wire [4:0] userNameInput0,
    input wire [4:0] userNameInput1,
    input wire [4:0] userNameInput2,
    input wire [4:0] userNameInput3,

    input wire[4:0] passwordInput0,
    input wire[4:0] passwordInput1,
    input wire[4:0] passwordInput2,
    input wire[4:0] passwordInput3,

    input wire flagResolve,

    output reg lock,
    output reg flag,        //when flag goes up error = incorrect password 
    output reg resetCount
    );

    reg [19:0] userList [7:0];    // Array of 8 elements, each 20 bits wide
    reg [19:0] userPassword [7:0]; // Array of 8 elements, each 20 bits wide
    reg [1:0] userMode [7:0];      // 0=admin, 1=user, 2=guest

    reg[19:0] tempUser;
    reg[19:0] tempPassword;

    integer userCount;
    
    integer currentUser;

    integer i;

    initial 
    begin
        userList[0] = 20'b00001000010000000000;
        userPassword[0] = 20'b00001000010000000000;
        userMode[0] = 2'b00;
        currentUser = 0;
        userCount = 1;
        lock = 1;
    end

    always @(posedge clk) 
    begin
        if(flag && flagResolve)
        begin
            flag = 0;
        end
        if(~lock)
        begin
            if(locker || btn1)
            begin
                if(userMode[currentUser] == 2)
                begin
                    // remove current user 
                    userCount = userCount - 1;
                    userList[currentUser][19:0] = userList[userCount][19:0];
                    userPassword[currentUser][19:0] = userPassword[userCount][19:0];
                    userMode[currentUser] = userMode[userCount];
                end
                lock = 1;
                resetCount = 0;
            end
            else if(userMode[currentUser][1:0] == 2'b00 || userMode[currentUser][1:0] == 2'b01)
            begin
                if(btn2)
                begin
                    // reset password
                    resetCount = 0;
                    if(inputCount == 4)
                    begin
                        userPassword[currentUser][19:0] = {userNameInput3[4:0], userNameInput2[4:0], userNameInput1[4:0], userNameInput0[4:0]};
                        // $display("New password: %b", userPassword[currentUser][19:0]);
                        resetCount = 1;
                    end
                    
                    
                end
                else if(userMode[currentUser][1:0] == 2'b00)
                begin
                    if(btn3)
                    begin
                        // add user 
                        resetCount = 0;
                        if(inputCount == 8)
                        begin
                            if(userCount < 8)
                            begin
                                userList[userCount] = {userNameInput3[4:0], userNameInput2[4:0], userNameInput1[4:0], userNameInput0[4:0]};
                                userPassword[userCount] = {passwordInput3[4:0], passwordInput2[4:0], passwordInput1[4:0], passwordInput0[4:0]};
                                if(switch1)
                                begin
                                    userMode[userCount] = 1;
                                end
                                else
                                begin
                                    userMode[userCount] = 2;
                                end
                                resetCount = 1;
                                userCount = userCount + 1;
                            end
                            else
                            begin
                                // alert too many usres
                                flag = 1;
                            end
                        end
                    end
                    else if(btn4)
                    begin
                        // change password
                        resetCount = 0;
                        if(inputCount == 8)
                        begin
                            resetCount = 1;
                            for(i=0; i<userCount; i=i+1)
                            begin
                                tempUser = userList[i][19:0];
                                tempPassword = userPassword[i][19:0];
                                if(tempUser[4:0] == userNameInput0 && tempUser[9:5] == userNameInput1 && tempUser[14:10] == userNameInput2 && tempUser[19:15] == userNameInput3)
                                begin
                                    userPassword[i] = {passwordInput3[4:0], passwordInput2[4:0], passwordInput1[4:0], passwordInput0[4:0]};
                                end
                            end
                        end

                    end
                    else if(btn5)
                    begin
                        // delete user 
                        resetCount = 0;
                        if(inputCount == 4)
                        begin
                            resetCount = 1;
                            for(i=0; i<userCount; i=i+1)
                            begin
                                tempUser = userList[i][19:0];
                                tempPassword = userPassword[i][19:0];
                                if(tempUser[4:0] == userNameInput0 && tempUser[9:5] == userNameInput1 && tempUser[14:10] == userNameInput2 && tempUser[19:15] == userNameInput3)
                                begin
                                    userCount = userCount - 1;
                                    userList[i][19:0] = userList[userCount][19:0];
                                    userPassword[i][19:0] = userPassword[userCount][19:0];
                                    userMode[i] = userMode[userCount];
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
                tempUser = userList[i][19:0];
                tempPassword = userPassword[i][19:0];
                if(tempUser[4:0] == userNameInput0 && tempUser[9:5] == userNameInput1 && tempUser[14:10] == userNameInput2 && tempUser[19:15] == userNameInput3)
                begin
                    if(tempPassword[4:0] == passwordInput0 && tempPassword[9:5] == passwordInput1 && tempPassword[14:10] == passwordInput2 && tempPassword[19:15] == passwordInput3)
                    begin
                        currentUser = i;
                        lock = 0;
                        resetCount = 1;
                    end
                    else
                    begin
                        flag = 1;
                    end;
                end
            end
        end
        
    end



endmodule