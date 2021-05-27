module counter_two(clk, rst, x, y);
	input clk, rst;
	output reg [7:0] x, y;

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) begin
			x <= 8'b0;
			y <= 8'b0;
		end
		else begin
			if(x==8'b11111111) begin
				x <= 8'b0;
				y <= y+1;
			end
			else
				x <= x+1;
		end
	end
endmodule
