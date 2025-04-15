# Create work library
vlib work

# Compile SystemVerilog files with access enabled
vlog -sv +acc task2.sv -Lf altera_mf_ver
vlog -sv +acc task1.sv -Lf altera_mf_ver
vlog -sv +acc dff.sv -Lf altera_mf_ver
vlog -sv +acc seg7.sv -Lf altera_mf_ver
vlog -sv +acc task1_tb.sv -Lf altera_mf_ver
vlog -sv +acc DE1_SoC.sv -Lf altera_mf_ver
vlog -sv +acc DE1_SoC_tb.sv -Lf altera_mf_ver
vlog -sv +acc ram32x3.qip -Lf altera_mf_ver
vlog -sv +acc ram32x3.v -Lf altera_mf_ver

# Launch simulation with access enabled
vsim -voptargs="+acc" -t 1ps -Lf altera_mf_ver work.task1_tb

# Load waveform view
do wave.do

# Run simulation
run -all
