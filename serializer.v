module serializer(load, clk, in, out, out_en);
	input load, clk;
	input [7:0] in;
	output out, out_en;
	reg out, out_en;
	reg [7:0] a, temp;
	
	always@(posedge clk) begin
		if(load == 1'b1) begin
			a <= in;
			temp <= 8'b11111111;
		end	
		else begin
			if(temp != 8'b0) begin		
			out <= a[0];
			out_en <= 1'b1;
			a <= a >> 1;
			temp <= temp >> 1;
			end
			else begin
				out <= 1'b0;
				out_en <= 1'b0;
			end
		end
	end
endmodule
