module con_test_lb(rst, clk, din, i_en, o_en, result, done);
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
	reg[2:0] f_cnt;

	wire[10:0] ad;

	reg [19:0] sum;
	reg [19:0] temp_flip; 
	reg [19:0] sum_flip;

	reg [10:0] w_ptr; 
	reg [10:0] r_ptr;
	reg [10:0] r_ptr_temp;	
	reg [10:0] r_cnt; // rPtr cnt
	reg [10:0] t_cnt; // total cnt

	
	reg [2:0] row;
	reg [2:0] col;

	assign ad = (count == 4'b0000) ? w_ptr : r_ptr_temp;
	assign c_r_en = (state == 1 && count == 4'b1010) ? 1'b1 : 1'b0;

	always@(*) begin
		if(count == 4'b0001) sum = 0;
		else sum = sum_flip;
		if(count == 4'b0001) temp_sum = 0;
		else temp_sum = (dout>>mul);
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

			if(count == 1 ||  count == 2 || count == 3) row = 0;
			else if(count == 4 || count == 5 || count == 6) row = 1;
			else row = 2;
	
			if(count == 1 || count == 4 || count == 7) col = 0;
			else if(count == 2 || count == 5 || count == 8) col = 1;
			else col = 2;
	
			if(r_ptr + 512 * row + col > 1026)
				r_ptr_temp = r_ptr + 512* row + col - 1027;
			else
				r_ptr_temp = r_ptr + 512 * row + col;
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
			f_cnt <= 1'b0;		

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
		end

		else begin

			if(i_en == 1'b1) begin
				temp_din <= din;
				count <= 0;
				wen <= 1'b1;
				w_state <= 1'b1;
			end
	
			else begin
				if(w_state == 1'b1) begin
					if(w_ptr == 1026) begin
						w_ptr <= 0;
						if(state == 1'b0) state <= 1'b1;
					end
					else w_ptr <= w_ptr + 1;
				end
				wen <= 1'b0;
				w_state <= 1'b0;
			end		
				


			if(state == 0 || f_cnt != 'b0) count <= 0;
			
			if(state == 1 && f_cnt != 'b0) begin
				count <= 0;
				if(w_state == 1'b1) f_cnt <= f_cnt - 1;	
			end

			else if(state == 1 && f_cnt == 'b0) begin
				if(t_cnt == 509 && r_cnt == 509 && count == 4'b1011) begin
					state <= 1'b0;
					done <= 1'b1;
				end
			
				else begin
					done <= 1'b0;	
					if(count == 4'b1011) begin
						if(i_en == 1'b1) count <= 4'b0000;
						else count <= 4'b1100;
					end
					else if(count != 4'b1100)  count <= count + 1;
				
					if(count == 4'b1011) begin
						if(r_cnt == 509) begin
							if(r_ptr + 3 > 1026) r_ptr <= r_ptr + 3 - 1027;
							else r_ptr <= r_ptr + 3;
							r_cnt <= 0;
							t_cnt <= t_cnt + 1;
							f_cnt <= 3'b011;
						end
						else begin
							if(r_ptr +1 > 1026) r_ptr <= r_ptr + 1 - 1027;
							else r_ptr <= r_ptr + 1;
							r_cnt <= r_cnt +1;
						end
					end
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
