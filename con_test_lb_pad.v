module con_test_lb_pad(rst, clk, din, i_en, o_en, result, done);
	input clk, rst;
	reg wen, csn;

	input [15:0] din;
	reg [15:0] temp_din;
	input i_en;

	output reg done;
	output reg o_en;

	wire [15:0] dout; 
	output reg[18:0] result; 


	reg[18:0] temp_sum;
	wire c_r_en;
	
	reg[10:0] din_ad;


	parameter QD = 4'b0010, OC = 4'b0011, HX = 4'b0100;
	reg[4:0] mul;

	reg[3:0] count;
	reg state; 
	reg w_state;

	wire signed [11:0] ad;

	reg [19:0] sum;
	reg [19:0] temp_flip; 
	reg [19:0] sum_flip;

	reg [10:0] w_ptr; 
	reg signed [11:0] r_ptr;
	reg signed [11:0] r_ptr_temp;	
	reg signed [11:0] r_cnt; // rPtr cnt
	reg signed [11:0] t_cnt; // total cnt

	reg signed [2:0] row;
	reg signed [2:0] col;

	reg p_state;
	reg t_state;
	reg r_f_state;

	assign ad = (count == 4'b0000) ? w_ptr : r_ptr_temp;
	assign c_r_en = (state == 1 && count == 4'b1010) ? 1'b1 : 1'b0;

	always@(*) begin
		if(count == 4'b0001) sum = 0;
		else sum = sum_flip;
		if(count == 4'b0001) temp_sum = 0;
		else begin
			if(t_state == 'b0) temp_sum = (dout>>mul);
			else temp_sum = 0;
		end
		temp_flip = temp_sum + sum;
	end

	always@(count) begin
		if(count != 4'b1100) begin
			if(count == 2 || count == 4 || count == 8 || count == 10)
				mul = HX;
			else if(count == 3 || count == 5 || count == 7 || count == 9)
				mul = OC;
			else 
				mul = QD;

			if(count == 1 ||  count == 2 || count == 3) row = -1;
			else if(count == 4 || count == 5 || count == 6) row = 0;
			else row = 1;
	
			if(count == 1 || count == 4 || count == 7) col = -1;
			else if(count == 2 || count == 5 || count == 8) col = 0;
			else col = 1;
			
			if(r_f_state == 1'b0) begin
				if(r_ptr + 512 * row + col > 1026)
					r_ptr_temp = r_ptr + 512* row + col - 1027;
				else
					r_ptr_temp = r_ptr + 512 * row + col;
			end

			else begin
				if(r_ptr + 512 * row + col < 0)
					r_ptr_temp = r_ptr + 512* row + col + 1027;
				else if(r_ptr + 512 * row + col > 1026)
					r_ptr_temp = r_ptr + 512 * row + col - 1027;
				else
					r_ptr_temp = r_ptr + 512 * row + col;
			end



			if(t_cnt + row < 0 || t_cnt + row > 511 || r_cnt + col < 0 || r_cnt + col > 511) begin
				p_state = 1'b1;
			end
			else begin
				p_state = 1'b0;
			end
		end
	end

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) begin
			count <= 4'b0000;
		
			csn <= 1'b0;
			wen <= 1'b0;
			state <= 1'b0;
			w_state <= 1'b0;
			result <= 1'b0;

			sum <= 1'b0;
			sum_flip <= 1'b0;
			temp_flip <= 1'b0;

			w_ptr <= 1'b0;
			r_ptr <= 1'b0;
			r_ptr_temp <= 0;

			r_cnt <= 1'b0;
			t_cnt <= 1'b0;
			done <= 1'b0;
			o_en <= 1'b0;
		
			p_state <= 1'b0;
			t_state <= 1'b0;
			r_f_state <= 1'b0;
		end

		else begin

			if(p_state == 1'b0) t_state = 1'b0;
			else t_state <= 1'b1;

			if(i_en == 1'b1) begin
				temp_din <= din;
				count <= 0;
				wen <= 1'b1;
				w_state <= 1'b1;
			end
	
			else begin
				if(w_state == 1'b1) begin
					if(w_ptr == 513) begin
						if(state == 1'b0) state <= 1'b1;
						w_ptr <= w_ptr + 1;
					end
					else if(w_ptr == 1026) w_ptr <= 0;
					else w_ptr <= w_ptr + 1;
				end
				wen <= 1'b0;
				w_state <= 1'b0;
			end		
				
			if(state == 0) count <= 0;
			else begin
				if(t_cnt == 511 && r_cnt == 511 && count == 4'b1011) begin
					state <= 1'b0;
					done <= 1'b1;
				end
			
				else begin
					done <= 1'b0;	
					if(count == 4'b1011) begin
						if(i_en == 1'b1) count <= 4'b0000;
						else count <= 4'b1100;

						if(r_ptr+1>1026) begin
							r_ptr <= r_ptr + 1 - 1027;
							if(r_f_state == 1'b0) r_f_state <= 1'b1;
						end
						else r_ptr <= r_ptr+1;

						if(r_cnt == 511) begin
							r_cnt <= 0;
							t_cnt <= t_cnt + 1;
						end
						else r_cnt <= r_cnt +1;
					end
					else if(count != 4'b1100)  count <= count + 1;
				end
			end
		
			if(c_r_en == 1'b1) begin
				result <= temp_flip;
				o_en <= 1'b1;
			end
			else o_en <= 1'b0;

			sum_flip <= temp_flip;
		end	
	end

	linebuffer u0(clk, csn, wen, ad, temp_din, dout);
endmodule
