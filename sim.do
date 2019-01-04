###########################
# Simple modelsim do file #
###########################

# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog mips_tb.v mips.v ALU32Bit.v alu_control.v \
mux2inputs_to_32bit.v control_unit.v \
data_memory.v instruction_mem.v \
mux2inputs_to_5bit.v pc_adder.v program_counter.v \
register_file.v \
sign_extension.v Next_PC.v\
mux2inputs_to_30bit.v

# Open testbench module for simulation

vsim -novopt work.testbench

# Add all testbench signals to waveform diagram

add wave sim:/testbench/*
#add wave -recursive -depth 10 *
#add wave *

#add wave -format Analog-Step -height 84 -max 15.0 -radix unsigned /testbench/*

onbreak resume

# Run simulation
run -all

wave zoom full


