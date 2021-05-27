`define memory 262143

module img_con(rst, clk, ren, o_en);
	input rst, clk, ren;
	output reg o_en;
	parameter HX=3'b100, OC=3'b011, QD=3'b100;
 
	wire [16:0] sum[0:memory];
	reg [15:0] data[0:memory];
	reg [15:0] temp;
	integer i, j;
	reg c_ren;
	integer cnt;
	reg op_cnt;


	wire mul_val;
	wire data_val;
	wire sum_en;


	assign data_val=data[i+j];

	assign mul_val=(cnt==0||cnt==2||cnt==6||cnt==8) ? HX :
					(cnt==1||cnt==3||cnt==5||cnt==7) ? OC : QD;

	assign sum_en = (cnt == 9)? 1'b1 : 1'b0;
	
		
	initial begin
		$readmemh("img.dat", data);
	end

	always@(cnt or c_ren) begin
		if(c_ren == 1'b1)
			cnt <= cnt + 4'b0001;
		if(cnt > 4'b1001) cnt <= 4'b0;
	end

	always@(posedge clk or rst) begin
		if(rst == 1'b1) begin
			o_en<='b0;
			i<='b0;
			j<='b0;
			c_ren<='b0;
			cnt<='b0;
			temp<='b0;
			sum<='b0;
			op_cnt<='b0;
		end
		else begin
			if(c_ren == 1'b0) begin
				if(ren == 1'b1) begin
					c_ren<=1'b1;
				end
			else begin
				if(i+2 < 512 && j+2 < 512) begin
												
					
	end
endmodule
