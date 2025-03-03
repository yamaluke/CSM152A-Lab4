module unlocker(
    input wire clk, 
    input wire locker, 

    input btn1,
    input btn2,
    input btn3,
    input btn4,
    input btn5,

    input wire [3:0] inputCount,
    

    input wire [4:0] userNameInput0,
    input wire [4:0] userNameInput1,
    input wire [4:0] userNameInput2,
    input wire [4:0] userNameInput3,

    input wire[4:0] passwordInput0,
    input wire[4:0] passwordInput1,
    input wire[4:0] passwordInput2,
    input wire[4:0] passwordInput3,

    output reg lock
    );

    reg [7:0][19:0] userList;
    reg [7:0][19:0] userPassword;
    reg [7:0][1:0] userMode;
    reg[19:0] tempUser;
    reg[19:0] tempPassword;
    
    integer currentUser;

    integer i;

    initial 
    begin
        userList[0][19:0] = 20'b00000000000000000000;
        userPassword[0][19:0] = 20'b00000000000000000000;
        lock = 1;
    end

    always @(posedge clk) 
    begin
        if(~lock)
        begin
            if(locker || btn1)
            begin
                if(userMode[currentUser][1:0] == 2'b10)
                begin
                    // remove current user 
                end
                lock = 1;
            end
            else if(userMode[currentUser][1:0] == 2'b00 || userMode[currentUser][1:0] == 2'b01)
            begin
                if(btn2)
                begin
                    // reset password
                end
                else if(userMode[currentUser][1:0] == 2'b00)
                begin
                    if(btn3)
                    begin
                        // add user 
                    end
                    else if(btn4)
                    begin
                        // change password
                    end
                    else if(btn3)
                    begin
                        // delete password 
                    end
                end
            end
        end
        else if(inputCount == 8)
        begin
            for(i=0; i<8; i=i+1)
            begin
                tempUser = userList[0][19:0];
                tempPassword = userPassword[0][19:0];
                if(tempUser[4:0] == userNameInput0 && tempUser[9:5] == userNameInput1 && tempUser[14:10] == userNameInput2 && tempUser[19:15] == userNameInput3)
                begin
                    if(tempPassword[4:0] == passwordInput0 && tempPassword[9:5] == passwordInput1 && tempPassword[14:10] == passwordInput2 && tempPassword[19:15] == passwordInput3)
                    begin
                        currentUser = i;
                        lock = 0;
                    end
                end
            end
        end
        
    end



endmodule