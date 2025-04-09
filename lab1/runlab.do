# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "fullAdder_tb.sv"
vlog "fullAdder.sv"
vlog "hw1p1.sv"
vlog "hw1p2.sv"
vlog "hw1p1_tb.sv"
vlog "hw1p2_tb.sv"


# Run simulation for hw1p1_tb
vsim -voptargs="+acc" -t 1ps -lib work hw1p1_tb
# Source the wave.do file
do wave.do
# Run simulation for hw1p1_tb
run -all

# Run simulation for hw1p2_tb
#vsim -voptargs="+acc" -t 1ps -lib work hw1p2_tb
# Source the wave.do file
#do wave.do
# Run simulation for hw1p2_tb
#run -all

# End
