module cnn(rst, clk, in, i_en, out, o_en);
	input rst, clk;
	input signed [7:0] in;
	input i_en;
	output reg signed [7:0] out;
	output reg o_en;
	parameter SO = 2'b0, SA = 2'b01, SB = 2'b10, QD = 2'b10, HF = 2'b01;
	reg [1:0] state, next;
	reg signed [7:0] in_temp;
	wire r_en, o_r_en;
	wire signed [7:0] sum;
	reg signed [7:0] r_1,r_2,r_3;

	assign sum = (r_1>>QD) + (r_2>>HF) + (in_temp>>QD);
	assign r_en = (state == SA) ? 1'b1 : 1'b0;
	assign o_r_en = (state == SB) ? 1'b1 : 1'b0;

always@(state or i_en) begin
	case(state)
		SO : if(i_en==1'b1) next = SA;
			else next = SO;
		SA : next = SB;
		SB : next = SO;
	endcase
end

always@(posedge clk or posedge rst) begin
	if(rst == 1'b1) begin
		state <= SO;
		r_1<='b0;
		r_2<='b0;
		r_3<='b0;
		out<='b0;
		o_en<='b0;
	end else begin
		if(i_en==1'b1) in_temp<=in;
		if(r_en==1'b1) begin
			r_1<=r_2;
			r_2<=r_3;
			r_3<=in_temp;
		end
		if(o_r_en==1'b1) begin
			 out<=sum;
			o_en<=1'b1;
		end
		state<=next;
	end
end

endmodule 
