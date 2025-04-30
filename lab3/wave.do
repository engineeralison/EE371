onerror {resume}
quietly WaveActivateNextPane {} 0


# Add signals related to task1 testbench
add wave -noupdate /task1_tb/clk
add wave -noupdate /task1_tb/reset
add wave -noupdate /task1_tb/write
add wave -noupdate /task1_tb/address
add wave -noupdate /task1_tb/dataIn
add wave -noupdate /task1_tb/dataOut


# Add signals related to carDetection testbench
#add wave -noupdate /task2/clk
#add wave -noupdate /task2/reset
#add wave -noupdate /task2/write
#add wave -noupdate /task2/dataIn
#add wave -noupdate /task2/address
#add wave -noupdate /task2/dataOut


# Add signals related to DE1_SoC testbench
add wave -noupdate /DE1_t_tb/clk
add wave -noupdate /DE1_SoC_tb/SW
add wave -noupdate /DE1_SoC_tb/KEY
add wave -noupdate /DE1_SoC_tb/HEX0
add wave -noupdate /DE1_SoC_tb/HEX1
add wave -noupdate /DE1_SoC_tb/HEX2
add wave -noupdate /DE1_SoC_tb/HEX3
add wave -noupdate /DE1_SoC_tb/HEX4
add wave -noupdate /DE1_SoC_tb/HEX5
add wave -noupdate /DE1_SoC_tb/LEDR
add wave -noupdate /DE1_SoC_tb/V_GPIO
add wave -noupdate /DE1_SoC_tb/writeAddr
add wave -noupdate /DE1_SoC_tb/dut/readAddr
add wave -noupdate /DE1_SoC_tb/dut/dataOut


# Update the signal tree and configure the waveform window
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {237 ps} 0}
quietly wave cursor active 1

# Configure waveform appearance
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps

# Zoom and cursor settings
update
WaveRestoreZoom {0 ps} {1276 ps}
