// Dominic Doty
// Mason Darveaux
// ECEN 5863
// Final Project
// Pong

// VGA is 640x480

// 640 pixels per line
// 480 lines per image
// pixel clock s/b 25.175 MHz
module vga(
	input clk, reset,
	input r, g, b,
	output [9:0] hscan, vscan,
	output hsync, vsync,
	output r, g, b);

	// Create counters here for hscan and vscan
	// hscan counts up
	// Take

	// Timing:
	// "Front Porch" delay .636us
	// hsync pulse 3.813 us
	// "Back Porch" 1.907 us
	// Active video 25.422 us

endmodule
