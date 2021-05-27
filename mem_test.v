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
				

module counter_sram(rst, clk, din, dout, x, y);
	input clk, rst;
	reg wen, csn;
	input[15:0] din;
	output[15:0] dout;

	output reg[7:0] x, y;
	reg[3:0] state, next;
	wire[`address:0] ad;
	
	assign ad = (state == 4'b0000) ? (y-1)*512+(x-1) : (state == 4'b0001) ? (y-1)*512+x : (state == 4'b0010) ? (y-1)*512+(x+1) : (state == 4'b0011) ? y*512+(x-1) : (state == 4'b0100) ? y*512+x : (state == 4'b0101) ? y*512+(x+1) : (state == 4'b0110) ? (y+1)*512+(x-1) : (state == 4'b0111) ? (y+1)*512+x : (y+1)*512+(x+1);

	always@(state) begin
		case(state)
			4'b0000 : next = 4'b0001;
			4'b0001 : next = 4'b0010;
			4'b0010 : next = 4'b0011;
			4'b0011 : next = 4'b0100;
			4'b0100 : next = 4'b0101;
			4'b0101 : next = 4'b0110;
			4'b0110 : next = 4'b0111;
			4'b0111 : next = 4'b1000;
			4'b1000 : next = 4'b1001;
			4'b1001 : next = 4'b0000;
		endcase
	end

	always@(posedge clk or posedge rst)begin
		if(rst == 1'b1) begin
			state <= 4'b0000;
			x <= 1;
			y <= 1;
			csn <= 1'b0;
			wen <= 1'b0;
		end
		else begin
			if (state == 4'b1000) csn <= 1'b1;
			else csn <= 1'b0;			

			if (state == 4'b1001) begin
				if (x==510) begin
					x <= 1;
					y <= y+1;
				end
				else
					x <= x+1;
			end
		state <= next;
		end
	end	

	sram u0(clk, csn, wen, ad, din, dout);
endmodule
