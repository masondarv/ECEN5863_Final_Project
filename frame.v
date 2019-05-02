// Doty Darveaux
// ECEN 5863
// Pong Final Project

module frame(
	input [9:0] hcount, vcount,
	output r, g, b );

	wire signal_frame;

	assign signal_frame = (hcount < 10) || (vcount < 10) || (hcount > 629) || (vcount > 469);

	assign r = signal_frame;
	assign g = signal_frame;
	assign b = signal_frame;

endmodule // frame
