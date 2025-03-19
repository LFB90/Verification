module tb();
    // Declare inputs and outputs
    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Clock generator
    always #(5ns) clk = ~clk;

    // Instantiate DUT
    dut u_dut(clk, rst, data_in, data_out);

    // Test data
    int test_data[4] = {0, 1, 2, 3};

    // Test loop
    initial begin
        // Reset DUT
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Loop over test data
        for (int i = 0; i < 4; i++) begin
            // Set input data
            data_in = test_data[i];

            // Wait for output data
            repeat (10) @(posedge clk);

            // Check output data
            if (data_out !== (test_data[i] + 1)) begin
                $error("Incorrect output data");
            end
        end

        // Finish test
        $display("Test passed");
        $finish;
    end
endmodule
