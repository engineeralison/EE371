# Create work library
vlib work

# Compile SystemVerilog files with access enabled
vlog -sv +acc sign_mag_add_tb.sv
vlog -sv +acc sign_mag_add.sv
vlog -sv +acc sync_rom.sv


# Launch simulation with access enabled
vsim -voptargs="+acc" -t 1ps work.sign_mag_add_tb

# Load waveform view
do wave.do

# Run simulation
run -all
