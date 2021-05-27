module comp_mul_one(rst, clk, a_r, a_i, b_r, b_i, i_en, o_r, o_i, o_en);
	input rst, clk;
	input signed[7:0] a_r, a_i;
	input signed[7:0] b_r, b_i;
	input i_en;
	output reg signed[16:0] o_r, o_i;
	output reg o_en;
	parameter SO = 3'b000, SA = 3'b001, SB = 3'b010, SC = 3'b011, SD = 3'b100;
	reg [2:0] state, next;
	reg signed[15:0] pp1, pp2;
	reg signed[7:0] a_r_temp, a_i_temp, b_r_temp, b_i_temp;
	reg cnt;
	wire pp1_en, pp2_en, o_r_en, o_i_en, sub;
	wire signed[7:0] a_op, b_op;
	wire signed[15:0] mul;
	wire signed[16:0] sum;

	assign a_op = (state == SA) ? a_r_temp : (state == SB) ? a_i_temp : (state == SC) ? a_r_temp : a_i_temp;

	assign b_op = (state == SA) ? b_r_temp : (state == SB) ? b_i_temp : (state == SC) ? b_i_temp : b_r_temp;

	assign sub = (state == SC) ? 1'b1 : 1'b0;

assign mul = a_op * b_op;

assign sum = (sub == 1'b1) ? pp1 - pp2 : pp1 + pp2;

assign pp1_en = (state == SA || state == SC) ? 1'b1 : 1'b0;
assign pp2_en = (state == SB || state == SD) ? 1'b1 : 1'b0;
assign o_r_en = (state == SC) ? 1'b1 : 1'b0;
assign o_i_en = (state == SO) ? 1'b1 : 1'b0;


always@(state or i_en) begin
	case(state)
		SO : if(i_en == 1'b1) next = SA;
			else next = SO;
		SA : next = SB;
		SB : next = SC;
		SC : next = SD;
		SD : next = SO;
	endcase
end

always@(posedge clk or posedge rst)
begin
	if(rst == 1'b1) begin
		state <= SO;
		pp1 <= 'b0;
		pp2 <= 'b0;
		o_r <= 'b0;
		o_i <= 'b0;
		o_en <= 'b0;
		cnt <= 'b0;
	end
	else begin
		if(i_en == 1'b1) begin	
			a_r_temp <= a_r;
			a_i_temp <= a_i;
			b_r_temp <= b_r;
			b_i_temp <= b_i;
			cnt <= 1'b0;
			o_en <= 1'b0;
		end
		else begin
			if(pp1_en == 1'b1) pp1 <= mul;
			if(pp2_en == 1'b1) pp2 <= mul;
			if(o_r_en == 1'b1) o_r <= sum;
			if(o_i_en == 1'b1) begin
				o_i <= sum;
				cnt <= 1'b1;
				if(cnt == 1'b0) o_en <= 1'b1;
				else o_en <= 1'b0;
			end
		end
		state <= next;
	end
end

endmodule
