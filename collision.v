// Doty Darveaux
// ECEN 5863
// Pong Final Project

module collision(
	input clk, rst,
	input paddle_1_sig,
	input paddle_2_sig,
	input ball_sig,
	input frame_sig,
   input vsync,
	output reg collision);

	reg delay_count;
		
	always @(posedge clk) begin
		if(rst) begin
			collision <=0;
			delay_count <= 0;
		end
		 
		 //if vsync has gone low signalling end of frame, set collision equal to 0, the change will not be noticed until the 
		 //next vsinc signal
		else if (!vsync) begin
			if(!delay_count) begin
				delay_count = 1;
			end
			else begin
				collision <= 0;
			end 
		end
		else begin
			if ((ball_sig && paddle_1_sig) || (ball_sig && paddle_2_sig) || (ball_sig && frame_sig)) begin
				collision <= 1;
				delay_count <= 0;
			end
		end 
	end

endmodule


