vlib work
vlog "memory_tb_testcases.v"
vsim tb +test_name=bd_wr_fd_rd
add wave -r sim:/tb/dut/*
run -all
