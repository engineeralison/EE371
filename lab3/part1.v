/* This top level module passes music through the FPGA, plays a static tone from memory,
 * and achieves noise filtering through FIR filter. Switch 9 is used to activate the
 * the static tone from memory and Switch 8 is used to activate the FIR filter.
 * This module also uses use the audio coder/decoder (CODEC) on the DE1-SoC to generate 
 * and filter noise from both an external source and an internal memory.
*/ 
module part1 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [9:0] SW;
	input [3:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	// Task 1: Passing Music Through the FPGA
	
	//assign writedata_left = readdata_left & write_ready;
	//assign writedata_right = readdata_right & write_ready;

	//assign read = read_ready & write_ready;
	//assign write = read_ready & write_ready;
	
	// Task 2: PLAY A TONE FROM MEMORY
	
	 wire [23:0] rom_output;
    wire rom_write_trigger;

    part2 task2_inst (.CLOCK_50(CLOCK_50),.reset(reset),.write(rom_write_trigger),.out(rom_output));
	 
	 // Use SW[9] to choose between passthrough and ROM playback
    //assign writedata_left  = SW[9] ? rom_output     : (readdata_left  & {24{write_ready}});
    //assign writedata_right = SW[9] ? rom_output     : (readdata_right & {24{write_ready}});
    //assign write           = write_ready;
    //assign read            = SW[9] ? read_ready     : (read_ready & write_ready);
    
	 // assign rom_write_trigger = SW[9] ? write_ready : 1'b0;
	
	// Task 3: FIR FILTER INTEGRATION
	// Raw sample: SW9 = 0 → passthrough from mic; SW9 = 1 → ROM tone
	wire [23:0] unfiltered_sample = SW[9] ? rom_output : readdata_left;

	// Convert to signed for FIR filter input
	wire signed [23:0] unfiltered_signed = unfiltered_sample;
	wire signed [23:0] filtered_sample;

	// FIR filter instance (Task 3)
	part3 #(.N(8), .N_LOG2(3)) fir_inst (.clk(CLOCK_50), .reset(reset), .enable(write_ready),.new_sample(unfiltered_signed), .filtered_out(filtered_sample));

	// Final output sample: SW8 = 1 → filtered; SW8 = 0 → unfiltered
	wire [23:0] output_sample = SW[8] ? (write_ready ? filtered_sample : 24'sd0)
												 : (unfiltered_sample & {24{write_ready}});

	// Assign to both channels
	assign writedata_left  = output_sample;
	assign writedata_right = output_sample;

	// Control read/write
	assign write = write_ready;
	assign read  = SW[9] ? read_ready : (read_ready & write_ready);

	// ROM trigger for Task 2
	assign rom_write_trigger = SW[9] ? write_ready : 1'b0;

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule // part 1


