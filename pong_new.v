


module pong_new(
				input CLOCK_50,
				input [3:0] KEY,
				inout [35:0] GPIO_0,
				output VGA_HS, VGA_VS, VGA_CLK,
				output [7:0] VGA_R, VGA_G, VGA_B
				);
				
	
	wire reset, clk;
	wire [9:0] hcount, vcount;
	wire myR, myG, myB;
				
	assign reset = !KEY[0];
	
	vga_pll pixel_clk (
		.refclk (CLOCK_50),		//  refclk.clk
		.rst (reset),				//   reset.reset
		.outclk_0 (clk) );		// outclk0.clk 
				
	vga vga_inst (
		.clk (clk),
		.reset (reset),
		.iR (myR),
		.iG (myG),
		.iB (myB),
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
		.r (myR),
		.g (myG),
		.b (myB)
	);
	
endmodule