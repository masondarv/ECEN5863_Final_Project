// Doty Darveaux
// ECEN 5863
// Pong Final Project

module paddle(
input clk, rst, vsync, up, down, player,
input [9:0] hcount, vcount,
output reg r, g, b
);

//paddle size is 48 pixels
//start paddle in the middle
reg [8:0] paddleStartPos = 9'd216;

always @(posedge clk)
begin
      if(rst) begin
          r <= 1'b0;
          g <= 1'b0;
          b <= 1'b0;
      end
      else begin
          //if paddle is for player one, output on left side of screen
          if(player == 1'b0) begin
              //write pixels high if the vga count is within the position of the paddle
              if((hcount < 7) && (hcount >2) && (vcount >= paddleStartPos) && (vcount <= (paddleStartPos+48))) begin
              r <= 1'b1;
              g <= 1'b1;
              b <= 1'b1;

              end
              else begin
              r <= 1'b0;
              g <= 1'b0;
              b <= 1'b0;
              end


          end
          // if the paddle is for player two, output on the right side of the screen
          else begin
              //write pixels high if the vga count is within the position of the paddle
              if((hcount < 638)  && (hcount > 633) && (vcount >= paddleStartPos) && (vcount <= (paddleStartPos+48))) begin
              r <= 1'b1;
              g <= 1'b1;
              b <= 1'b1;

              end
              else begin
              r <= 1'b0;
              g <= 1'b0;
              b <= 1'b0;
              end
          end

      end

end


always @(negedge vsync)
begin

	 //reset paddle position
	 if(rst ==1'b1) begin
	 paddleStartPos <= 9'd216;
	 end

	 else begin

			//button is active low

			 if(up== 1'b0) begin
				  if(paddleStartPos <= 3) begin
						paddleStartPos <=3;

				  end

				  else begin
						paddleStartPos <= paddleStartPos -1;
				  end

			 end

			 else if (down ==1'b0) begin
				  if(paddleStartPos >= 429) begin
						paddleStartPos <=429;

				  end

				  else begin
						paddleStartPos <= paddleStartPos +1;
				  end

			 end
			 //if neither button is pressed, paddle position remains the same
			 else begin
				  paddleStartPos <= paddleStartPos;

			 end

		end


end




endmodule
