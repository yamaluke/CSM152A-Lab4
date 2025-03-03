module unlocker(
    input wire locker, //feed 2hz
    input wire rst,
    input wire pause,
    input wire sel,
    input wire adj,

    input wire [4:0] userNameInput0,
    input wire [4:0] userNameInput1,
    input wire [4:0] userNameInput2,
    input wire [4:0] userNameInpue3,

    input wire[4:0] passwordInput0,
    input wire[4:0] passwordInput1,
    input wire[4:0] passwordInput2,
    input wire[4:0] passwordInput3,

    output reg lock
    );

    reg [19:0][7:0] userList;
    reg [19:0][7:0] userPassword;
    reg[19:0] tempUser;
    integer i;

    always @(posedge clk) 
    begin
        for(i=0; i<8; i=i+1)
        begin
            tempUser = userList[19:0][i];
            if(tempUser[4:0] == userNameInput0 && tempUser[9:5] == userNameInput1 && tempUser[14:10] == userNameInput2 && tempUser[19:15] == userNameInpue3)
            begin
                
            end
        end
    end



endmodule