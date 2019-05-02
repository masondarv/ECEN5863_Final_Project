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
				
	
	wire hard_reset, reset, clk;
	wire [9:0] hcount, vcount;
	wire comb_R, comb_G, comb_B;
	 
	assign hard_reset = SW[9];
	assign reset = SW[8] || game_over_p2 || game_over_p1;
	
	assign comb_R = frame_R || centerline_R || pad0_R || pad1_R || ball_R || p1_score_R || p2_score_R;
	assign comb_G = frame_G || centerline_G || pad0_G || pad1_G || ball_G || p1_score_G || p2_score_G;
	assign comb_B = frame_B || centerline_B || pad0_B || pad1_B || ball_B || p1_score_B || p2_score_B;

	wire collision;


	vga_pll pixel_clk (
		.refclk (CLOCK_50),		//  refclk.clk
		.rst (hard_reset),		//   reset.reset
		.outclk_0 (clk) );		// outclk0.clk 


	vga vga_inst (
		.clk (clk),
		.reset (hard_reset),
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
		.hcount (hcount),
		.vcount (vcount),
		.r (frame_R),
		.g (frame_G),
		.b (frame_B)
	);

	wire frame_sig, frame_R, frame_G, frame_B;
	assign frame_sig = frame_R || frame_G || frame_B;

	
	centerline(
		.hcount (hcount),
		.vcount (vcount),
		.r (centerline_R),
		.g (centerline_G),
		.b (centerline_B)
	);
	
	wire centerline_R, centerline_G, centerline_B;
	
	
	paddle #(0) p1(
		.clk (clk),
		.rst (reset),
		.vsync (VGA_VS),
		.up (KEY[3]),
		.down (KEY[2]),
		.hcount (hcount),
		.vcount (vcount),
		.r (pad0_R),
		.g (pad0_G),
		.b (pad0_B)
	);

	wire pad0_sig, pad0_R, pad0_G, pad0_B;
	assign pad0_sig = pad0_R || pad0_G || pad0_B;
	

	paddle #(1) p2(
		.clk (clk),
		.rst (reset),
		.vsync (VGA_VS),
		.up (KEY[1]),
		.down (KEY[0]),
		.hcount (hcount),
		.vcount (vcount),
		.r (pad1_R),
		.g (pad1_G),
		.b (pad1_B)
	);

	wire pad1_sig, pad1_R, pad1_G, pad1_B;
	assign pad1_sig = pad1_R || pad1_G || pad1_B;
	
	wire p1_score_pulse, p2_score_pulse;
	

	ball ball_inst(
		.clk (clk),
		.reset (reset),
		.hcount (hcount),
		.vcount (vcount),
		.vsync (VGA_VS),
		.collision (collision),
		.temp (LEDR),	// TEMPORARY FOR TESTING
		.r (ball_R),
		.g (ball_G),
		.b (ball_B),
		.p1score(p1_score_pulse),
		.p2score(p2_score_pulse)
	);
	
	wire ball_sig, ball_R, ball_G, ball_B;
	assign ball_sig = ball_R || ball_G || ball_B;


	score #(30, 10, 220, 20) p1_score(
		.clk (clk),
		.reset (reset),
		.hcount (hcount),
		.vcount (vcount),
		.score_pulse (p1_score_pulse), // need to wire to ball for scores
		 .game_over (game_over_p1), // should be wired to something to reset the game
		.r (p1_score_R),
		.g (p1_score_G),
		.b (p1_score_B)
	);

	wire p1_score_R, p1_score_G, p1_score_B;
	
	wire game_over_p2, game_over_p1;
	
	score #(30, 10, 390, 20) p2_score(
		.clk (clk),
		.reset (reset),
		.hcount (hcount),
		.vcount (vcount),
		.score_pulse (p2_score_pulse), // need to wire to ball for scores
		 .game_over (game_over_p2), // should be wired to something to reset the game
		.r (p2_score_R),
		.g (p2_score_G),
		.b (p2_score_B)
	);

	wire p2_score_R, p2_score_G, p2_score_B;


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