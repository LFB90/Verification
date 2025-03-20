module toggle_circuit(input clk, input reset, output reg out);
    reg [7:0] counter = 8'h00;
    always @(posedge clk) begin
        if(reset) begin
            counter <= 8'h00;
        end else begin
            counter <= counter + 1;
        end
    end
    always @(posedge clk) begin
        out <= ~out;
    end
endmodule
