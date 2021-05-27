`define memory 524288
`define address 18	

module sram(clk, csn, wen, a, din, dout);
	input clk, csn, wen;
	input [`address:0] a;
	input [15:0] din;
	output [15:0] dout;

	reg[15:0] data[0:`memory];
	reg[`address:0] a_reg;

	initial begin
		$readmemh("img.dat", data);
	end

	always@(posedge clk) begin
		if(csn==1'b0) begin
			if(wen==1'b1) data[a] <= din;
			a_reg<=a;
		end
	end
	assign dout = data[a_reg];
endmodule
				

module counter_sram(rst, clk, din, dout, i_en);
	input clk, rst;
	reg wen, csn;
	input[15:0] din;
	input i_en;

	output [15:0] dout;
	reg[8:0] x, y;
	reg[3:0] count, next;
	reg state;
	reg[7:0] val_x, val_y;	

	wire[`address:0] ad;

	assign ad = (count != 4'b1001) ? val_y*512 + val_x : -255;

	always@(count or i_en) begin
		if(state == 1'b0) begin
			if(i_en == 1'b1)
				state <= 1'b1;
		end

		if(count == 4'b0000 || count == 4'b0001 || count == 4'b0010)
			val_y <= y-1;
		else if(count == 4'b0011 || count == 4'b0100 || count == 4'b0101)
			val_y <= y;
		else
			val_y <= y+1;

		if(count == 4'b0000 || count == 4'b0011 || count == 4'b0110)
			val_x <= x-1;
		else if(count == 4'b0001 || count == 4'b0100 || count == 4'b0111)
			val_x <= x;
		else
			val_x <= x+1;
	
		if(count == 4'b1001)
			next <= 4'b0000;
		else if(count == 4'b0000) begin
			if(state == 1'b1) next <= count + 1;
			else next <= count;
		end
		else next <= count + 1;
	end

	always@(posedge clk or posedge rst) begin
		if(rst == 1'b1) begin
			count <= 4'b1001;
			x <= 0;
			y <= 1;
			csn <= 1'b0;
			wen <= 1'b0;
			state <= 1'b0;
		end
		else begin
			if (count == 4'b1001) begin
				if (x==510) begin
					x <= 1;
					y <= y+1;
				end
				else
					x <= x+1;
			end
			if(y == 510 && x == 510) state <= 1'b0;
			count <= next;
		end
	end	

	sram u0(clk, csn, wen, ad, din, dout);
endmodule
