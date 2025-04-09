onerror {resume}
quietly WaveActivateNextPane {} 0

# Add signals related to hw1p1 (Problem 1)
add wave -noupdate /hw1p1_tb/dut/hw1p1/clk
add wave -noupdate /hw1p1_tb/dut/hw1p1/reset
add wave -noupdate /hw1p1_tb/dut/hw1p1/x
add wave -noupdate /hw1p1_tb/dut/hw1p1/y
add wave -noupdate /hw1p1_tb/dut/hw1p1/s
add wave -noupdate /hw1p1_tb/dut/hw1p1/Q
add wave -noupdate /hw1p1_tb/dut/hw1p1/fullAdder/a
add wave -noupdate /hw1p1_tb/dut/hw1p1/fullAdder/b
add wave -noupdate /hw1p1_tb/dut/hw1p1/fullAdder/cin
add wave -noupdate /hw1p1_tb/dut/hw1p1/fullAdder/sum
add wave -noupdate /hw1p1_tb/dut/hw1p1/fullAdder/count

# Add signals related to hw1p2 (Problem 2)
add wave -noupdate /hw1p2_tb/dut/hw1p2/clk
add wave -noupdate /hw1p2_tb/dut/hw1p2/reset
add wave -noupdate /hw1p2_tb/dut/hw1p2/in
add wave -noupdate /hw1p2_tb/dut/hw1p2/out
add wave -noupdate /hw1p2_tb/dut/hw1p2/ps
add wave -noupdate /hw1p2_tb/dut/hw1p2/ns


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
