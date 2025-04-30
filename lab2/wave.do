onerror {resume}
quietly WaveActivateNextPane {} 0

# DUT signals from DE1_SoC_tb
add wave -noupdate /task1_tb/dut/clk
add wave -noupdate /task1_tb/dut/addr
add wave -noupdate /task1_tb/dut/dataIn
add wave -noupdate /task1_tb/dut/dataOut
add wave -noupdate /task1_tb/dut/write

add wave -noupdate /DE1_SoC_tb/dut/CLOCK_50
add wave -noupdate /DE1_SoC_tb/dut/SW
add wave -noupdate /DE1_SoC_tb/dut/KEY
add wave -noupdate /DE1_SoC_tb/dut/HEX0
add wave -noupdate /DE1_SoC_tb/dut/HEX1
add wave -noupdate /DE1_SoC_tb/dut/HEX2
add wave -noupdate /DE1_SoC_tb/dut/HEX3
add wave -noupdate /DE1_SoC_tb/dut/HEX4
add wave -noupdate /DE1_SoC_tb/dut/HEX5
add wave -noupdate /DE1_SoC_tb/dut/LEDR
add wave -noupdate /DE1_SoC_tb/dut/DataIn_debug
add wave -noupdate /DE1_SoC_tb/dut/DataOut_debug


# Optional: if DUT exposes internal signals (like rdaddress, Write, DataIn/Out)
# add wave -noupdate /DE1_SoC_tb/dut/rdaddress
# add wave -noupdate /DE1_SoC_tb/dut/Write
# add wave -noupdate /DE1_SoC_tb/dut/DataIn
# add wave -noupdate /DE1_SoC_tb/dut/DataOut

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} 500ps} 0}
quietly wave cursor active 1

# Configure display
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps

update
WaveRestoreZoom {0 ps} {2000 ps}
