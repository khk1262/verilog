module top;
	reg rst, clk;
    reg [7:0] a_r, a_i, b_r, b_i;
	reg i_en;
	wire[16:0] o_r, o_i;
	wire o_en;	
initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;	
end

initial begin
	#1;
	rst = 1'b1;
	#6;
	rst = 1'b0;
	i_en = 1'b1;
	#5;
	a_r = 8'b00000011;
	a_i = 8'b00000001;
	b_r = 3;
	b_i = 2;
	#10;
	i_en = 1'b0;
	#50;
	i_en = 1'b1;
	a_r = 6;
	a_i = 4;
	b_r = 2;
	b_i = 5;
	#10;
	i_en = 1'b0;
	#100;
	$finish;	
end

always begin
	#5; clk = ~clk;
end

initial begin
$vcdplusfile("comp_mul_one.vpd");
$vcdpluson(0, top);
end
comp_mul_one(rst, clk, a_r, a_i, b_r, b_i, i_en, o_r, o_i, o_en);
endmodule
