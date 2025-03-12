module countDown(
    input wire clk, // 1hz
    input wire countDownActive,

    output reg [3:0] s10,
    output reg [3:0] s1
    );

    reg [1:0] activeSet;

    initial 
    begin
        activeSet <= 2'b00;
        s10 <= 7;
        s1 <= 9;
    end

    always @(posedge clk) 
    begin
        activeSet <= {activeSet[0], countDownActive};
        if(activeSet == 2'b01)
        begin
            s10 <= 6;
            s1 <= 0;
        end
        else if(countDownActive && ((s1 != 0) || (s10 != 0)))
        begin
            if (s1 === 0)
            begin
                s10 <= s10 - 1;
                s1 <= 9;
            end
            else
            begin
                s1 <= s1 - 1;
            end
        end
        else if(~countDownActive)
        begin
            s10 <= 7;
            s1 <= 9;    
        end
    end



endmodule