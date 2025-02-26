module counter (
  input clk,
  input rst,
  output reg [7:0] count
);

always @(posedge clk or negedge rst) begin
  if (rst) begin
    count <= 8'd0;
  end else begin
    if (count == MAX_VALUE) begin
      count <= 8'd0;
    end else begin
      count <= count + 1;
    end
  end
end

endmodule
