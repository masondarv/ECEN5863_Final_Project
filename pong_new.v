


module test(
				input CLOCK_50,
				input [3:0] KEY,
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
		.hcount (hcount),
		.vcount (vcount),
		.hsync (VGA_HS),
		.vsync (VGA_VS),
		.oR (VGA_R),
		.oG (VGA_G),
		.oB (VGA_B)
	);
	
	assign VGA_CLK = CLOCK_50;

	assign myR = &(hcount & 10'hF0);
	assign myG = !(&(hcount & 10'hF0));
	assign myB = !(myR || myG);
	
endmodule