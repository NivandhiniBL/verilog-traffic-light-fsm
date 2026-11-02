module traffic_light #(
    parameter RED_T = 5, GREEN_T = 4, YELLOW_T = 2   // clock cycles per state
)(
    input  wire clk, rst,
    output reg  red, green, yellow
);
    localparam S_RED = 2'd0, S_GREEN = 2'd1, S_YELLOW = 2'd2;
    reg [1:0] state, next;
    reg [7:0] cnt;

    wire done = (state == S_RED    && cnt == RED_T-1)   ||
                (state == S_GREEN  && cnt == GREEN_T-1) ||
                (state == S_YELLOW && cnt == YELLOW_T-1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin state <= S_RED; cnt <= 0; end
        else if (done) begin state <= next; cnt <= 0; end
        else cnt <= cnt + 1;
    end

    always @(*) begin
        case (state)
            S_RED:    next = S_GREEN;
            S_GREEN:  next = S_YELLOW;
            S_YELLOW: next = S_RED;
            default:  next = S_RED;
        endcase
    end

    always @(*) begin       // Moore outputs depend only on state
        {red, green, yellow} = 3'b000;
        case (state)
            S_RED:    red    = 1;
            S_GREEN:  green  = 1;
            S_YELLOW: yellow = 1;
        endcase
    end
endmodule
