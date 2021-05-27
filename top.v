module top;
	reg d, clk, rst, en;
	wire q;

	initial begin
		clk = 1'b0;
		rst = 1'b0;
		en = 1'b0;
		#5; rst = 1'b1;
		#20; rst = 1'b0;
		#60; en = 1'b1;
		#20; en = 1'b0;
		#40; en = 1'b1;
	end
	always begin
		#10;
		clk = ~clk;
	end
initial begin
	d = 1'b0;
	#55;
	d = 1'b1;
	#60;
	d = 1'b0;
	#60;
	$finish;
end
initial begin
//	$monitor(a,b,s);
$vcdplusfile("df.vpd");
$vcdpluson(0,top);
end
endmodule
