// Doty Darveaux
// ECEN 5863
// Pong Final Project

module ball(
	input clk, reset,
	input [9:0] hcount, vcount,
	input vsync,
	input collision,
	output reg r, g, b );

	reg [9:0] ball_x, ball_y;
	reg signed [3:0] ball_vect_x, ball_vect_y;	// Stores the motion vector for the ball (current location is incremented by this at every frame transition

	always @(posedge clk) begin
		if(reset) begin
			// Place the ball in the middle and give it motion
			ball_x <= 320;		// 640/2
			ball_y <= 240;		// 480/2
			ball_vect_x <= 2;	// Start with a 45 degree vector
			ball_vect_y <= 2;
		end
		else begin
			// output pixels for the ball
			if((hcount == ball_x) && (vcount == ball_y)) begin
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
	end

	always @(negedge vsync) begin
		// we're at a frame sync
		// update the ball location

    // we're colliding, update the vector and do not change ball position
		if(collision) begin

			// if ball is colliding with top or bottom of frame, flip the y vector
			if(ball_y < 2 || ball_y >478) begin
				 ball_vect_y <= -ball_vect_y;
			end

				// we're hitting a paddle, flip the x vector
			else if( ((ball_x < 7 ) && (ball_x >2 )) || ((ball_x > 633) && (ball_x<638)) && ((ball_y >=2) && (ball_y <= 478)) ) begin
				 ball_vect_x <= -ball_vect_x;
			end

				// player 2 scores, stop the ball, add a point for player 2
			else if(ball_x < 2) begin
				ball_vect_x <= 0;
				ball_vect_y <= 0;
			end

			//player 1 scores, stop the ball, add a point for player 1
			else if(ball_x > 637) begin
				ball_vect_x <= 0;
				ball_vect_y <= 0;
			end


		end

		// we're not colliding, leave the vector unchanged and update ball location
		else begin
			ball_x <= ball_x + ball_vect_x;
			ball_y <= ball_y + ball_vect_y;

		end


	end


endmodule // frame
