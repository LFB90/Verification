cd /home/runner
export PATH=/usr/bin:/bin:/tool/pandora64/bin:/apps/vcsmx/vcs/S-2021.09//bin
export VCS_VERSION=S-2021.09
export VCS_PATH=/apps/vcsmx/vcs/S-2021.09//bin
export LM_LICENSE_FILE=27020@10.116.0.5
export VCS_HOME=/apps/vcsmx/vcs/S-2021.09/
export HOME=/home/runner
export UVM_HOME=/apps/vcsmx/vcs/S-2021.09//etc/uvm-ieee
vcs -licqueue '-timescale=1ns/1ns' '+vcs+flush+all' '+warn=all' '-sverilog' '+define+S50' '+define+VERBOSE' '+define+VCS' '-debug_access+all' '-cm' 'line+tgl+assert' '+plusarg_save' '-debug_access+all' +incdir+$UVM_HOME/src $UVM_HOME/src/uvm.sv $UVM_HOME/src/dpi/uvm_dpi.cc -CFLAGS -DVCS design.sv testbench.sv  && ./simv +vcs+lic+wait '+UVM_TESTNAME=test_doubles'  ; echo 'Creating result.zip...' && zip -r /tmp/tmp_zip_file_123play.zip . && mv /tmp/tmp_zip_file_123play.zip result.zip