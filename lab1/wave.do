onerror {resume}
quietly WaveActivateNextPane {} 0


# Add signals related to carCounter testbench
#add wave -noupdate /carCounter_tb/clk
#add wave -noupdate /carCounter_tb/reset
#add wave -noupdate /carCounter_tb/incr
#add wave -noupdate /carCounter_tb/decr
#add wave -noupdate /carCounter_tb/out

# Add signals related to carDetection testbench
#add wave -noupdate /carDetection_tb/clk
#add wave -noupdate /carDetection_tb/reset
#add wave -noupdate /carDetection_tb/outer
#add wave -noupdate /carDetection_tb/inner
#add wave -noupdate /carDetection_tb/enter
#add wave -noupdate /carDetection_tb/exit


# Add signals related to DE1_SoC testbench
add wave -noupdate /DE1_SoC_tb/CLOCK_50
add wave -noupdate /DE1_SoC_tb/HEX0
add wave -noupdate /DE1_SoC_tb/HEX1
add wave -noupdate /DE1_SoC_tb/HEX2
add wave -noupdate /DE1_SoC_tb/HEX3
add wave -noupdate /DE1_SoC_tb/HEX4
add wave -noupdate /DE1_SoC_tb/HEX5

add wave -noupdate /DE1_SoC_tb/dut/enter
add wave -noupdate /DE1_SoC_tb/dut/exit
add wave -noupdate /DE1_SoC_tb/dut/count

add wave -noupdate /DE1_SoC_tb/dut/V_GPIO
add wave -noupdate /DE1_SoC_tb/V_GPIO_in
add wave -noupdate /DE1_SoC_tb/V_GPIO_dir



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
