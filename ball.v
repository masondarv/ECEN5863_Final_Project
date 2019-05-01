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
		if(collision) begin
			// we're colliding, update the vector
			if((ball_x == 0)) begin
			end
			if((ball_y > 1)) begin
			end

			// hit left or right

			if((ball_x < 5) || (ball_x > 634)) begin
				// we're hitting the paddle or score wall

				if((ball_x < 2) || (ball_x > 637)) begin
					// hitting a score wall
				end
				else begin
					// hitting a paddle
				end
			end
			// hit left or right paddle
			// hit top or bottom
		end
		// we're not colliding, leave the vector

		// update the location
		ball_x <= ball_x + ball_vect_x;
		ball_y <= ball_y + ball_vect_y;
	end


endmodule // frame