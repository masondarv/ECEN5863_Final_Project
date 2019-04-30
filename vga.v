// Dominic Doty
// Mason Darveaux
// ECEN 5863
// Final Project
// Pong

// VGA is 640x480

// 640 pixels per line
// 480 lines per image
//  clock s/b 25.176 MHz
module vga(
	input clk, reset,
	input r, g, b,
	output [9:0] hcount, vcount,
	output hsync, vsync,
	output r, g, b);

	// Create counters here for hscan and vscan
	reg [9:0] hcount_raw;
	reg [9:0] vcount_raw;


	always @(posedge clk) begin
		if(reset) begin
			hcount_raw <= 0;
			vcount_raw <= 0;
			hcount <= 0;
			vcount <= 0;
		end
		else begin
			// Counters - Raw including sync
			hcount_raw <= hcount_raw + 1;
			if(hcount_raw >= 800) begin
				hcount_raw <= 0;
				vcount_raw <= vcount_raw + 1;
				if(vcount_raw >= 525) begin
					vcount_raw = 0;
				end
			end

			// Sync signals
			if(hcount_raw >= 640) begin
				hsync <= 0;
				hcount <= 0;
			end
			else begin
				hsync <= 1;
				hcount <= hcount_raw;
			end

			if(vcount_raw >= 480) begin
				vsync <= 0;
				vcount <= 0;
			end
			else begin
				vsync <= 1;
				vcount <= hcount_raw;
			end
		end
	end
	
	


endmodule
