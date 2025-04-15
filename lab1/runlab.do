# Create work library
vlib work

# Compile SystemVerilog files with access enabled
vlog -sv +acc fullAdder.sv
vlog -sv +acc fullAdder_tb.sv
vlog -sv +acc carCounter.sv
vlog -sv +acc carDetection.sv
vlog -sv +acc DE1_SoC.sv
vlog -sv +acc DE1_SoC_tb.sv

# Launch simulation with access enabled
vsim -voptargs="+acc" -t 1ps work.DE1_SoC_tb

# Load waveform view
do wave.do

# Run simulation
run -all
