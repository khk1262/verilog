module df(d, clk, rst, en, q);
	input d, clk, rst, en;
	output q;
	reg q;

	always@(posedge clk or posedge rst) begin
	if(rst == 1'b1) q <= 1'b0;
	else begin		
	if(en == 1'b1) q <= d;
	end
end
endmodule
