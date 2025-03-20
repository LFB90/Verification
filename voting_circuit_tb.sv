module voting_circuit_tb();
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    wire [7:0] out;
    voting_circuit dut(in1, in2, in3, out);
    initial begin
        in1 = 8'h05;
        in2 = 8'h08;
        in3 = 8'h10;
        #10;
        in1 = 8'h12;
        in2 = 8'h07;
        in3 = 8'h04;
        #10;
        in1 = 8'h01;
        in2 = 8'h01;
        in3 = 8'h20;
        #10;
        $finish;
    end
endmodule
