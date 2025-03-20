module counter_tb();
    reg clk = 0;
    reg reset = 0;
    wire [7:0] count;
    counter dut(clk, reset, count);
    initial begin
        $monitor("Count = %h", count);
        reset = 1;
        #10;
        reset = 0;
    end
    always #5 clk = ~clk;
endmodule
