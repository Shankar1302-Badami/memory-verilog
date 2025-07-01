# Verilog Memory Project

This project implements a memory design in Verilog with simulation testbenches and backdoor access using `.hex` files.

## Files Included

- `memory.v` – RTL of memory
- `memory_tb.v` – Testbench
- `memory_tb_testcases.v` – Custom test logic
- `run.do` – ModelSim simulation script
- `input.hex` – Memory initialization
- `output.hexa` – Output memory dump

## How to Simulate

Run this in ModelSim:
```tcl
vlib work
vlog memory_tb_testcases.v
vsim tb +test_name = ........
do run.do
