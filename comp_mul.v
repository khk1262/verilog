module comp_mul(rst, clk, a_r, a_i, b_r, b_i, i_en, o_r, o_i);
	input rst, clk;
	input signed [7:0] a_r, a_i;
	input signed [7:0] b_r, b_i;
	input i_en;
	output reg signed [16:0] o_r, o_i;

	parameter SA = 1'b0, SB = 1'b1;
	reg state, next;
	wire b_sel, sub, o_r_en, o_i_en;
	wire signed [7:0] b_op1, b_op2;
	wire signed [15:0] mul1, mul2;
	wire signed [16:0] sum;

	assign b_op1 = (b_sel == 1'b0) ? b_r : b_i;
	assign mul1 = a_r * b_op1;
	
	assign b_op2 = (b_sel == 1'b0) ? b_i : b_r;
	assign mul2 = a_i * b_op2;

	assign sum = (sub == 1'b0) ? mul1+mul2 : mul1-mul2;

	assign b_sel = (state == SA) ? 1'b0 : 1'b1;
	assign sub = (state == SA) ? 1'b1 : 1'b0;
	assign o_r_en = (state == SA) ? 1'b1 : 1'b0;
	assign o_i_en = (state == SA) ? 1'b0 : 1'b1;


	always@(state or i_en) begin
		case(state)
			SA : if(i_en == 1'b1) next = SB;
				else next = SA;
			SB : next = SA;
		endcase
	end

	always@(posedge clk or posedge rst)
	begin
		if(rst == 1'b1) begin
			state <= SA;
			o_r <= 'b0;
			o_i <= 'b0;
		end else begin
			state <= next;
			if(o_r_en == 1'b1) o_r <= sum;
			if(o_i_en == 1'b1) o_i <= sum;
		end
	end
endmodule
