// Dominic Doty
// Mason Darveaux
// ECEN 5863
// Final Project
// Pong

// REFERENCE
// https://timetoexplore.net/blog/arty-fpga-vga-verilog-01

// VGA is 640x480

// 640 pixels per line
// 480 lines per image
// clock s/b 25.176 MHz
module vga(
	input clk, reset,
	input iR, iG, iB,
	output wire blank, sync,
	output [9:0] hcount, vcount,
	output hsync, vsync,
	output [7:0] oR, oG, oB);

	// timing parameters
	parameter res_horz = 640;
	parameter res_vert = 480;
	parameter front_porch_horz = 16;
	parameter back_porch_horz = 48;
	parameter sync_horz = 96;
	parameter total_blanking_horz = front_porch_horz + back_porch_horz + sync_horz;
	parameter total_horz = res_horz + front_porch_horz + back_porch_horz + sync_horz;
	parameter front_porch_vert = 10;
	parameter back_porch_vert = 33;
	parameter sync_vert = 2;
	parameter total_blanking_vert = front_porch_vert + back_porch_vert + sync_vert;
	parameter total_vert = res_vert + front_porch_vert + back_porch_vert + sync_vert;
	
	// Blank and Sync
	assign	sync	=	1'b1;																			// Not used
	
	// Feed through RGB signals
	assign oR = iR ? 8'hFF : 8'h00;
	assign oG = iG ? 8'hFF : 8'h00;
	assign oB = iB ? 8'hFF : 8'h00;
	
	// Create counters here for hscan and vscan
	reg [9:0] hcount_raw;
	reg [9:0] vcount_raw;
	
	// Sync Signals
	assign hsync = ~((hcount_raw >= front_porch_horz) & (hcount_raw < (front_porch_horz + sync_horz)));
	assign vsync = ~((vcount_raw >= (res_vert + front_porch_vert)) & (vcount_raw < (res_vert + front_porch_vert + sync_vert)));

	// Keep x and y wihtin active pixels
	assign hcount = (hcount_raw < total_blanking_horz) ? 10'h00 : (hcount_raw - total_blanking_horz);
	assign vcount = (vcount_raw >= res_vert) ? (res_vert - 10'h01) : vcount_raw;

	// Blanking Signal
	assign blank = ~((hcount_raw < total_blanking_horz) | (vcount_raw > res_vert-1));

	always @(posedge clk) begin
		if(reset) begin
			hcount_raw <= 0;
			vcount_raw <= 0;
		end
		else begin
			// Counters - Raw including sync
			hcount_raw <= hcount_raw + 1'b1;
			if(hcount_raw >= total_horz) begin
				hcount_raw <= 0;
				vcount_raw <= vcount_raw + 1'b1;
				if(vcount_raw >= total_vert) begin
					vcount_raw <= 0;
				end
			end
		end
	end
endmodule
