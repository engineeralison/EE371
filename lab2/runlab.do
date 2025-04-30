# =============================================================================
# runlab.do - Script to compile and simulate the DE1_SoC design
# =============================================================================

# Create work library
vlib work

# Compile all Verilog files
vlog "./seg7.sv"
vlog "./task1.sv"
vlog "./task2.sv"
vlog "./ram32x3.v" -Lf altera_mf_ver
vlog "./ram32x3port2.v" -Lf altera_mf_ver
vlog "./lights.sv"
vlog "./DE1_SoC.sv"
vlog "./DE1_SoC_tb.sv"   

# Run simulation on DE1_SoC_tb
#vsim -voptargs="+acc" -t 1ps -lib work DE1_SoC_tb 
vsim -voptargs="+acc" -t 1ps -lib work DE1_SoC_tb -L altera_mf_ver


# Load waveform display config
do wave.do              ;# <-- renamed wave file to match testbench

# Set views
view wave
view structure
view signals

# Run simulation
run -all
