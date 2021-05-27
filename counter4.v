module counter4(clk, rst, o);
	input clk, rst;
	output [3:0] o;
	reg [3:0] o;

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) o <= 4'b0;
		else o <= o + 1;

	end
endmodule
