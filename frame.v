// Doty Darveaux
// ECEN 5863
// Pong Final Project

module frame(
	input clk, reset,
	input [9:0] hcount, vcount,
	output r, g, b );

	wire signal_frame, signal_midline;

	assign signal_frame = (hcount < 10) || (vcount < 10) || (hcount > 629) || (vcount > 469);
	assign signal_midline = (hcount > 318) && (hcount < 322) && (vcount & 10'h008);

	assign r = signal_frame || signal_midline;
	assign g = signal_frame || signal_midline;
	assign b = signal_frame || signal_midline;

endmodule // frame
