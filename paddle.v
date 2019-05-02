// Doty Darveaux
// ECEN 5863
// Pong Final Project

module paddle(
input clk, rst, vsync, up, down,
input [9:0] hcount, vcount,
output [8:0] paddle_pos,
output r, g, b
);

parameter player = 0;

wire paddle_out;

//paddle size is 48 pixels
//start paddle in the middle
reg [8:0] paddleStartPos = 9'd216;


always @(negedge vsync or posedge rst)
begin
	 //reset paddle position
	 if(rst) begin
		paddleStartPos <= 9'd216;
	 end
	 else begin
		//button is active low
		if(!up) begin
			if(paddleStartPos <= 16) begin
				paddleStartPos <= 16;
			end
			else begin
				paddleStartPos <= paddleStartPos - 9'h05;
			end
		end
		else if (!down) begin
			if(paddleStartPos >= 415) begin
				paddleStartPos <= 415;
			end
			else begin
				paddleStartPos <= paddleStartPos + 9'h05;
			end
		end
		//if neither button is pressed, paddle position remains the same
	end
end

// Paddle Output
assign paddle_out = !player ?
					((hcount < 24) && (hcount >14) && (vcount >= paddleStartPos) && (vcount <= (paddleStartPos+48))) : 
					((hcount < 625)  && (hcount > 615) && (vcount >= paddleStartPos) && (vcount <= (paddleStartPos+48)));

assign r = paddle_out;
assign g = paddle_out;
assign b = paddle_out;

// Output Paddle Position
assign paddle_pos = paddleStartPos;

endmodule