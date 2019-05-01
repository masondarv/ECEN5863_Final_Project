// Doty Darveaux
// ECEN 5863
// Pong Final Project

module frame(
	input clk, reset,
	input [9:0] hcount, vcount,
	output reg r, g, b );

  always @(posedge clk)

  begin
      if(reset)  begin
      r <= 1'b0;
      g <= 1'b0;
      b <= 1'b0;
      end

      else begin

          //if the horizontal or vertical count is at the position of the frame, drive the vga output high
          if((hcount < 10) || (vcount < 10) || (hcount > 629) || (vcount > 469) ) begin
              r <= 1'b1;
              g <= 1'b1;
              b <= 1'b1;
          end
          //otherwise drive the vga output low 
          else begin
            r <= 1'b0;
            g <= 1'b0;
            b <= 1'b0;

          end

        end

  end



endmodule // frame
