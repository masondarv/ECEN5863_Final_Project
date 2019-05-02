// Doty Darveaux
// ECEN 5863
// Pong Final Project

module ball(
	input clk, reset,
	input [9:0] hcount, vcount,
	input vsync,
	input collision,
	output reg temp,	// TEMPORARY FOR TESTING
	output reg r, g, b );

	reg [9:0] ball_x, ball_y;
	reg signed [3:0] ball_vect_x, ball_vect_y;	// Stores the motion vector for the ball (current location is incremented by this at every frame transition

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
			ball_x = 40;		// 640/2
			ball_y = 40;		// 480/2
			ball_vect_x = 2;	// Start with a 45 degree vector
			ball_vect_y = 2;
		end
		else begin
			// we're at a frame sync
			// update the ball location

			// we're colliding, update the vector and do not change ball position
			if(collision) begin
				
				// if ball is colliding with top or bottom of frame, flip the y vector
				if(ball_y < 15) begin
					ball_vect_y = +2;
				end
				else if(ball_y > 463) begin
					ball_vect_y = -2;
				end

					// we're hitting a paddle, flip the x vector
				else if((ball_x < 37 ) && (ball_x >20 )) begin
					ball_vect_x = 2;
				end
				else if((ball_x > 602) && (ball_x<619)) begin
					ball_vect_x = -2;
				end

					// player 2 scores, stop the ball, add a point for player 2
				else if(ball_x <= 20) begin
					ball_vect_x = 0;
					ball_vect_y = 0;
				end

				//player 1 scores, stop the ball, add a point for player 1
				else if(ball_x >= 619) begin
					ball_vect_x = 0;
					ball_vect_y = 0;
				end
				
				ball_x = ball_x + ball_vect_x;
				ball_y = ball_y + ball_vect_y;

			end

			// we're not colliding, leave the vector unchanged and update ball location
			else begin
				ball_x = ball_x + ball_vect_x;
				ball_y = ball_y + ball_vect_y;
				temp = 0;// TEMPORARY FOR TESTING
			end
		end


	end


endmodule // frame
