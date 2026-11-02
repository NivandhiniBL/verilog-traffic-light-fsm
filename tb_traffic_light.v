`timescale 1ns/1ps
module tb_traffic_light;
    reg clk = 0, rst = 1;
    wire red, green, yellow;
    integer errors = 0, i;

    traffic_light #(5,4,2) dut(clk, rst, red, green, yellow);
    always #5 clk = ~clk;

    task check(input r, g, y, input [127:0] name);
        if ({red,green,yellow} !== {r,g,y}) begin
            errors = errors + 1;
            $display("FAIL %0s at %0t", name, $time);
        end
    endtask

    initial begin
        $dumpfile("tb.vcd"); $dumpvars(0, tb_traffic_light);
        #12 rst = 0;
        // after reset: RED for 5 cycles
        for (i = 0; i < 5; i = i + 1) begin check(1,0,0,"RED");    @(posedge clk); #1; end
        for (i = 0; i < 4; i = i + 1) begin check(0,1,0,"GREEN");  @(posedge clk); #1; end
        for (i = 0; i < 2; i = i + 1) begin check(0,0,1,"YELLOW"); @(posedge clk); #1; end
        check(1,0,0,"RED again");
        // reset behaviour mid-sequence
        #7 rst = 1; #10 check(1,0,0,"RESET->RED"); rst = 0;
        if (errors == 0) $display("PASS: all checks passed");
        else $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
