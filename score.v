// Doty Darveaux
// ECEN 5863
// Pong Final Project

module score(
	input clk, reset,
	input [9:0] hcount, vcount,
	input score_pulse,
	output reg game_over,
	output r, g, b );

	parameter seg_length = 30;
	parameter seg_width = 10;
	parameter seg_x = 200;
	parameter seg_y = 20;

	// These hold the actual score counts
	reg unsigned [3:0] score;
	reg [6:0] score_segs;
	
	// Wires to connect all the segments
	wire [6:0] seg_outputs;

	always @(posedge clk) begin
		if(reset)  begin
			score = 0;
		end
		else begin
			// Add to score if a score pulse is high
			if(score_pulse) begin
				score <= score + 4'h1;
				
				// Score maxed out, reset the game
				if(score == 10) begin
					game_over <= 1;
				end
			end

			// Decode Score
			case (score)
				0 : score_segs <= 7'b0111111;
				1 : score_segs <= 7'b0000110;
				2 : score_segs <= 7'b1011011;
				3 : score_segs <= 7'b1001111;
				4 : score_segs <= 7'b1100110;
				5 : score_segs <= 7'b1101101;
				6 : score_segs <= 7'b1111101;
				7 : score_segs <= 7'b0000111;
				8 : score_segs <= 7'b1111111;
				9 : score_segs <= 7'b1100111;
				default: score_segs <= 7'b0111111;
			endcase
		end
	end
	
	// Seg 0
	assign seg_outputs[0] =	score_segs[0] &&
							(hcount > seg_x) &&
							(hcount < (seg_x + seg_length)) &&
							(vcount > seg_y) &&
							(vcount < (seg_y + seg_width));
	
	// Seg 1
	assign seg_outputs[1] =	score_segs[1] &&
							(hcount > (seg_x + seg_length - seg_width)) &&
							(hcount < (seg_x + seg_length)) &&
							(vcount > seg_y) &&
							(vcount < (seg_y + seg_length));
	
	// Seg 2
	assign seg_outputs[2] =	score_segs[2] &&
							(hcount > (seg_x + seg_length - seg_width)) &&
							(hcount < (seg_x + seg_length)) &&
							(vcount > (seg_y + seg_length - seg_width)) &&
							(vcount < (seg_y + (seg_length + seg_length - seg_width)));
	
	// Seg 3
	assign seg_outputs[3] =	score_segs[3] &&
							(hcount > seg_x) &&
							(hcount < (seg_x + seg_length)) &&
							(vcount > (seg_y + seg_length + seg_length - seg_width - seg_width)) &&
							(vcount < (seg_y + seg_length + seg_length - seg_width));

	// Seg 4
	assign seg_outputs[4] =	score_segs[4] &&
							(hcount > (seg_x)) &&
							(hcount < (seg_x + seg_width)) &&
							(vcount > (seg_y + seg_length - seg_width)) &&
							(vcount < (seg_y + (seg_length + seg_length - seg_width)));

	// Seg 5
	assign seg_outputs[5] =	score_segs[5] &&
							(hcount > (seg_x)) &&
							(hcount < (seg_x + seg_width)) &&
							(vcount > seg_y) &&
							(vcount < (seg_y + seg_length));
	
	
	// Seg 6
	assign seg_outputs[6] =	score_segs[6] &&
							(hcount > seg_x) &&
							(hcount < (seg_x + seg_length)) &&
							(vcount > (seg_y + seg_length - seg_width)) &&
							(vcount < (seg_y + seg_length));
	
	
	// Reductive OR all the seg outputs
	assign r = |seg_outputs;
	assign g = |seg_outputs;
	assign b = |seg_outputs;
	
endmodule