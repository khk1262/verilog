module register(a, clk, rst, en, b);
	input clk, rst, en;
	input [3:0] a;
	output [3:0] b;
	reg [3:0] b;

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) b <= 4'b0;
		else begin
			if(en == 1'b1) b <= a;
		end
	end
endmodule
