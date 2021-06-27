module counter_sram(rst, clk, result, i_en, done);
	input clk, rst;
	reg wen, csn;
	input i_en;
	reg [15:0] din;
	wire [15:0] dout;
	output reg[19:0] result;

	reg[18:0] temp_sum;
	wire o_r_en;
	
	reg[18:0] din_ad;

	output reg done;

	parameter QD = 4'b0010, OC = 4'b0011, HX = 4'b0100;
	reg[4:0] mul;

	reg[8:0] x, y;
	reg[3:0] count;
	reg state;
	reg[8:0] val_x, val_y;	

	wire[`address:0] ad;

	reg [19:0] sum;
	reg [19:0] temp_flip; 
	reg [19:0] sum_flip;
	assign ad = (count != 4'b1001 && count != 4'b1010) ? val_y*512 + val_x : din_ad;
	assign o_r_en = (x != 0 && count == 4'b1001) ? 1'b1 : 1'b0;

	always@(*) begin
		if(count == 0) sum = 0;
		else sum = sum_flip;
		if(count == 0) temp_sum = 0;
		else temp_sum = (dout>>mul);
		temp_flip = temp_sum + sum;
	end

	always@(count) begin
		if(count == 1 || count == 3 || count == 7 || count == 9)
			mul = HX;
		else if(count == 2 || count == 4 || count == 6 || count == 8)
			mul = OC;
		else 
			mul = QD;


		if(count == 4'b0000 || count == 4'b0001 || count == 4'b0010)
			val_y = y-1;
		else if(count == 4'b0011 || count == 4'b0100 || count == 4'b0101)
			val_y = y;
		else 
			val_y = y+1;

		if(count == 4'b0000 || count == 4'b0011 || count == 4'b0110)
			val_x = x-1;
		else if(count == 4'b0001 || count == 4'b0100 || count == 4'b0111)
			val_x = x;
		else
			val_x = x+1;
	end

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) begin
			count <= 4'b1010;
			x <= 0;
			y <= 1;
			csn <= 1'b0;
			wen <= 1'b0;
			state <= 1'b0;
			result <= 1'b0;
			sum <= 1'b0;
			sum_flip <= 1'b0;
			temp_flip <= 1'b0;
			din_ad <= 262144;
		end
		else begin
			if(count == 4'b1010) begin
				count <= 4'b0000;
				din_ad <= din_ad + 1;
			end
			else if(count == 4'b0000) begin
				if(state == 1'b1) count <= count + 1;
			end
			else count <= count + 1;
			
			if(state==1'b0) begin	
				if(i_en == 1'b1)
					state <= 1'b1;
				else
					state <= 1'b0;
				if(y == 510 && x == 510 && count == 4'b1010) begin
					done <= 1'b1;
				end
				else begin
					done <= 1'b0;
				end
			end
			else begin
				if(y == 510 && x == 510) begin
					state <= 1'b0;
				end
			end

			if (count == 4'b1010) begin
				if (x==510) begin
					x <= 1;
					y <= y+1;
				end
				else
					x <= x+1;
			end
				
			if(o_r_en==1'b1) begin
				result <= temp_flip;
				wen <= 1'b1;
				din <= temp_flip;
			end
			else begin
				wen <= 1'b0;
			end

			sum_flip <= temp_flip;
		end
	end	
	sram u0(clk, csn, wen, ad, din, dout);
endmodule
