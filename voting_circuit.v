module voting_circuit(input [7:0] in1, input [7:0] in2, input [7:0] in3, output reg [7:0] out);
    always @(in1, in2, in3) begin
        if((in1 > in2) && (in1 > in3)) begin
            out <= in1;
        end else if((in2 > in1) && (in2 > in3)) begin
            out <= in2;
        end else begin
            out <= in3;
        end
    end
endmodule
