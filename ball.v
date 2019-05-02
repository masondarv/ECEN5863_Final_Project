// Doty Darveaux
// ECEN 5863
// Pong Final Project

module ball(
	input clk, reset,
	input [9:0] hcount, vcount,
	input vsync,
	input collision,
	input signed [9:0] p1_pad_pos, p2_pad_pos,
	output reg [9:0] debug_out,
	output reg r, g, b,
	output reg p1score, p2score
  );

	reg signed [10:0] ball_x, ball_y;
	reg signed [7:0] ball_vect_x, ball_vect_y;	// Stores the motion vector for the ball (current location is incremented by this at every frame transition

	always @(posedge clk) begin
		// output pixels for the ball
		if(((hcount >= ball_x - 2) && (hcount <= ball_x + 2)) && ((vcount >= ball_y - 2) && (vcount <= ball_y + 2))) begin //((hcount == ball_x) && (vcount == ball_y)) begin
			// We're at the ball, output color
			r <= 1;
			g <= 1;
			b <= 1;
		end
		else begin
			// We're not at the ball, output zero
			r <= 0;
			g <= 0;
			b <= 0;
		end
	end

	always @(negedge vsync or posedge reset) begin
		if(reset) begin
			// Place the ball in the middle and give it motion
			ball_x = 320;		// 640/2
			ball_y = 240;		// 480/2
			ball_vect_x = 2;	// Start with a 45 degree vector
			ball_vect_y = 2;
			debug_out = 10'd0;
		end
		else begin
			// we're at a frame sync
			// update the ball location

			// we're colliding, update the vector and do not change ball position
			if(collision) begin
				debug_out[0] = 1'b1;
				
				// if ball is colliding with top or bottom of frame, flip the y vector
				if(ball_y < 15) begin
					debug_out[1] = 1'b1;
					ball_vect_y = -ball_vect_y;
				end
				else if(ball_y > 463) begin
					debug_out[2] =1'b1;
					ball_vect_y = -ball_vect_y;
				end

					// we're hitting a paddle, flip the x vector
				else if((ball_x < 26 ) && (ball_x > 12 )) begin
					debug_out[3] =1'b1;
					ball_vect_x = (p1_pad_pos + 24 - ball_y) > 0 ? (p1_pad_pos + 24 - ball_y)/3 : -(p1_pad_pos + 24 - ball_y)/3;
					ball_vect_y = (ball_y - p1_pad_pos - 24)/3;
				end
				else if((ball_x > 613) && (ball_x < 627)) begin
					debug_out[4] =1'b1;
					ball_vect_x = (p2_pad_pos + 24 - ball_y) > 0 ? -(p2_pad_pos + 24 - ball_y)/3 : (p2_pad_pos + 24 - ball_y)/3;
					ball_vect_y = (ball_y - p2_pad_pos - 24)/3;
				end

					// player 2 scores, stop the ball, add a point for player 2
				else if(ball_x <= 12) begin
					debug_out[5] =1'b1;
					ball_vect_x = 2;
					ball_vect_y = 2;
					p2score =1;
					ball_x = 320;
					ball_y = 240;
				end

				//player 1 scores, stop the ball, add a point for player 1
				else if(ball_x >= 627) begin
					debug_out[6] =1'b1;
					ball_vect_x = -2;
					ball_vect_y = -2;
					p1score=1;
					ball_x = 320;
					ball_y = 240;
				end

				ball_x = ball_x + ball_vect_x;
				ball_y = ball_y + ball_vect_y;

			end

			// we're not colliding, leave the vector unchanged and update ball location
			else begin
				p2score =0;
				p1score =0;
				debug_out[7] =1'b1;
				ball_x = ball_x + ball_vect_x;
				ball_y = ball_y + ball_vect_y;
			end
		end


	end


endmodule // frame
