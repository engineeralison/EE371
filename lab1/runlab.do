# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "fullAdder_tb.sv"
vlog "fullAdder.sv"
vlog "carCounter.sv"


# Run simulation
vsim -voptargs="+acc" -t 1ps -lib work carCounter_tb
# Source the wave.do file
do wave.do

# Run simulation for carCounter_tb
run -all

# End
