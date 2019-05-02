// Doty Darveaux
// ECEN 5863
// Pong Final Project

module centerline(
	input [9:0] hcount, vcount,
	output r, g, b );

	wire signal_midline;

	assign signal_midline = (hcount > 318) && (hcount < 322) && (vcount & 10'h008);

	assign r = signal_midline;
	assign g = signal_midline;
	assign b = signal_midline;

endmodule // frame
