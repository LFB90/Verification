property prop_crc_valid;
  // Assertion checks if CRC is valid
  @(posedge clk) ($rose(crc_done)) |-> (crc_valid == 1);
endproperty

cover crc_valid_coverage {
  // Coverage bins count how often the assertion is true
  // or false for different scenarios
  bins crc_valid_true = (prop_crc_valid == 1);
  bins crc_valid_false = (prop_crc_valid == 0);
}

assert property (prop_crc_valid);
