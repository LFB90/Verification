module ram_single_port
#(
    parameter ADDR_WIDTH = 16,
              DATA_WIDTH = 32
)
(
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output wire [DATA_WIDTH-1:0] dout
);

  reg [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0]; //Size of datatype / Quantity of Registers

always @(posedge clk) begin
    if (we == 1) // write data to address 'addr'
        mem[addr] <= din;
end

// read data from current addr
assign dout = mem[addr];

endmodule
