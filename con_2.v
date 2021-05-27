  `define m_size 524288 

module sram(clk, csn, wen, a, din, dout);
	input clk;
	input csn;
	input wen;
	input [19:0] a;
	input [15:0] din;
	input [15:0] dout;
	
	reg [15:0] data[0:m_size];
	reg [19:0] a_reg;

	always@(posedge clk) begin
		if(csn==1'b0) begin
			if(wen==1'b0) $readmemh("img.dat", data);
			a_reg <= a;
		end
	end
	
	assign dout = data[a_reg];
endmodule
	


module con_2(rst, clk, ren, oen);
	input rst, clk;
	input ren, oen;
	reg [15:0] data[0:m_size];
	reg [15:0] out[0:m_size];
	
	parameter HX=3'b100, OC=2'b11, QD=2'b10;
	parameter S0=4'b0, S1=4'b0001, S2=4'b0010, S3=4'b0011, S4=4'b0100, S5=4'b0101, S6=4'b0110, S7=4'b0111, S8=4'b1000, S9=4'b1001;
	parameter cycle=512;	

	reg[3:0] state, next;
	reg[18:0] cnt;
	reg[8:0] cycle_cnt;
	reg[1:0] row, col;
	
	reg c_ren;
	
	wire [15:0] sum;
	reg [4:0] ker;
	reg [15:0] ex_data;

	wire out_en;

	assign sum = sum + (ex_data >> ker);
	assign out_en = (state == S9) ? 1'b1 : 1'b0;


	always@(state or c_ren) begin
		case(state)
			S0: if(c_ren==1'b1)
				next = S1;
				else begin 
					next = S0;
					ker = OC;
					
				end
			S1: begin
					next = S2;
					ker = HX;
				end
			S2: begin
					next = S3;
					ker = OC;
				end
			S3: begin
					next = S4;
					ker = QD;
				end
			S4: begin
					next = S5;
					ker = OC;
				end
			S5: begin
					next = S6;
					ker = HX;
				end
			S6: begin
					next = S7;
					ker = OC;
			S7: begin
					next = S8;
					ker = HX;
				end
			S8: begin
					next = S9;
				end
			S9: begin
					next = S0;
					ker = HX;
				end
		endcase
	end

	always@(posedge clk or posedge rst) begin
		if(rst==1'b1) begin
			state <= S0;
			cnt <= 'b0;
			cycle_cnt <= 'b0;
			row <= 'b0;
			col <= 'b0;
			ker <= HX;
			ex_data <= 'b0;
		end	else begin
			if(ren == 1'b1) c_ren <= 1'b1;
	
