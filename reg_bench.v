module reg_bench;
	reg a, clk, rst, en;
	wire b;

	initial begin
		clk = 1'b0;
		rst = 1'b0;
		en = 1'b0;
		#5; rst = 1'b0;
		#20; rst = 1'b0;
		#60; en = 1'b0;
		#20; en = 1'b0;
		#40; en = 1'b0;
	end
	always begin
		#10;
		clk = ~clk;
	end
	initial begin
		a = 4'b0010;
		#55;
		a = 4'b0101;
		#60;
		a = 4'b1011;
		#60;
		$finish;
	end
	initial begin
	$vcdplusfile("register.vpd");
	$vcdpluson(0,reg_bench);
end
register dut(a,clk, rst, en, b);
endmodule	
