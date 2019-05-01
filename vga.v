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
	input iR, iG, iB,
	output wire blank, sync,
	output reg [9:0] hcount, vcount,
	output reg hsync, vsync,
	output [7:0] oR, oG, oB);

	// timing parameters
	parameter res_horz = 640;
	parameter res_vert = 480;
	parameter front_porch_horz = 16;
	parameter back_porch_horz = 48;
	parameter sync_horz = 96;
	parameter total_horz = res_horz + front_porch_horz + back_porch_horz + sync_horz;
	parameter front_porch_vert = 10;
	parameter back_porch_vert = 33;
	parameter sync_vert = 2;
	parameter total_vert = res_vert + front_porch_vert + back_porch_vert + sync_vert;
	
	
	// Blank and Sync
	assign	sync	=	1'b1;																			// Not used
	assign	blank	=	~((hcount_raw>(res_horz-1))||(vcount_raw>(res_vert-1)));		// blanks the RGB outputs
	
	assign oR = iR;
	assign oG = iG;
	assign oB = iB;
	
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
			hcount_raw <= hcount_raw + 1'b1;
			if(hcount_raw >= total_horz) begin
				hcount_raw <= 0;
				vcount_raw <= vcount_raw + 1'b1;
				if(vcount_raw >= total_vert) begin
					vcount_raw <= 0;
				end
			end

			// Output counts if in legit screen area
			if(hcount_raw < res_horz) begin
				hcount <= hcount_raw;
			end
			else begin
				hcount <= 0;
			end

			if(vcount_raw < res_vert) begin
				vcount <= vcount_raw;
			end
			else begin
				vcount <= 0;
			end
			
			// Sync signals
			if((hcount_raw >= (res_horz + front_porch_horz)) && (hcount_raw <= (res_horz + front_porch_horz + sync_horz))) begin
				hsync <= 0;
			end
			else begin
				hsync <= 1'b1;
			end

			if((vcount_raw >= (res_vert + front_porch_vert)) && (vcount_raw <= (res_vert + front_porch_vert + sync_vert))) begin
				vsync <= 0;
			end
			else begin
				vsync <= 1'b1;
			end
		end
	end
	
endmodule
