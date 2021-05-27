module top;
	reg rst, clk;
	reg [7:0] in;
	reg i_en;
	wire[7:0] out;

initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
end

initial begin
	#5;
	rst = 1'b1;
	#5;
	rst = 1'b0;
	i_en = 1'b1;
	#5;
	in = 16;
	#10;
	i_en = 1'b0;
	#30;
	i_en = 1'b1;
	in = 32;
	#10;
	i_en = 1'b0;
	#30;
	i_en = 1'b1;
	in = 8;
	#10;
	i_en = 1'b0;
	#100;
	$finish;
end

always begin
	#5; clk = ~clk;
end

initial begin
$vcdplusfile("cnn.vpd");
$vcdpluson(0, top);
end
cnn(rst, clk, in, i_en, out, o_en);
endmodule

