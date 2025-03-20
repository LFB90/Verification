module toggle_circuit_tb();
    reg clk = 0;
    reg reset = 0;
    wire out;
    toggle_circuit dut(clk, reset, out);
    initial begin
        $monitor("Out = %b", out);
        reset = 1;
        #10;
        reset = 0;
    end
    always #5 clk = ~clk;
endmodule
