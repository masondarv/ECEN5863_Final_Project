// Doty Darveaux
// ECEN 5863
// PONG


module pong_new(
				input CLOCK_50,
				input [3:0] KEY,
				input [9:0] SW,
				output [9:0] LEDR,
				inout [35:0] GPIO_0,
				output VGA_HS, VGA_VS, VGA_CLK, VGA_SYNC_N, VGA_BLANK_N,
				output [7:0] VGA_R, VGA_G, VGA_B
				);
				
	
	wire reset, clk;
	wire [9:0] hcount, vcount;
	wire comb_R, comb_G, comb_B;
	 
	assign reset = SW[9];
	
	assign comb_R = frame_R || pad0_R || pad1_R || ball_R;
	assign comb_G = frame_G || pad0_G || pad1_G || ball_G;
	assign comb_B = frame_B || pad0_B || pad1_B || ball_B;

	wire collision;
	
	vga_pll pixel_clk (
		.refclk (CLOCK_50),		//  refclk.clk
		.rst (reset),			//   reset.reset
		.outclk_0 (clk) );		// outclk0.clk 
				 
	vga vga_inst (
		.clk (clk),
		.reset (reset),
		.iR (comb_R),
		.iG (comb_G),
		.iB (comb_B),
		.blank (VGA_BLANK_N),
		.sync (VGA_SYNC_N),
		.hcount (hcount),
		.vcount (vcount),
		.hsync (VGA_HS),
		.vsync (VGA_VS),
		.oR (VGA_R),
		.oG (VGA_G),
		.oB (VGA_B)
	);
	
	assign VGA_CLK = clk;

	
	frame frame_inst(
		.clk (clk),
		.reset (reset),
		.hcount (hcount),
		.vcount (vcount),
		.r (frame_R),
		.g (frame_G),
		.b (frame_B)
	);

	wire frame_sig, frame_R, frame_G, frame_B;
	assign frame_sig = frame_R || frame_G || frame_B;

	
	paddle p1(
		.clk (clk),
		.rst (reset),
		.vsync (VGA_VS),
		.up (KEY[3]),
		.down (KEY[2]),
		.player (0),
		.hcount (hcount),
		.vcount (vcount),
		.r (pad0_R),
		.g (pad0_G),
		.b (pad0_B)
	);

	wire pad0_sig, pad0_R, pad0_G, pad0_B;
	assign pad0_sig = pad0_R || pad0_G || pad0_B;
	
	paddle p2(
		.clk (clk),
		.rst (reset),
		.vsync (VGA_VS),
		.up (KEY[1]),
		.down (KEY[0]),
		.player (1),
		.hcount (hcount),
		.vcount (vcount),
		.r (pad1_R),
		.g (pad1_G),
		.b (pad1_B)
	);

	wire pad1_sig, pad1_R, pad1_G, pad1_B;
	assign pad1_sig = pad1_R || pad1_G || pad1_B;
	
	ball ball_inst(
		.clk (clk),
		.reset (reset),
		.hcount (hcount),
		.vcount (vcount),
		.vsync (VGA_VS),
		.collision (collision),
		.temp (temp),	// TEMPORARY FOR TESTING
		.r (ball_R),
		.g (ball_G),
		.b (ball_B)
	);
	
	wire temp;						// TEMPORARY FOR TESTING
	assign GPIO_0[0] = temp;	// TEMPORARY FOR TESTING
	
	wire ball_sig, ball_R, ball_G, ball_B;
	assign ball_sig = ball_R || ball_G || ball_B;

	collision coll_inst(
		.clk (clk),
		.rst (reset),
		.paddle_1_sig (pad0_sig),
		.paddle_2_sig (pad1_sig),
		.ball_sig (ball_sig),
		.frame_sig (frame_sig),
		.vsync (VGA_VS),
		.collision (collision)
	);
		
endmodule