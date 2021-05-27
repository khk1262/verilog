module top;
	reg clk, rst;
	wire [8:0] x, y;
initial begin
	clk = 1'b0;
	rst = 1'b0;
	#5; rst = 1'b1;
	#20; rst = 1'b0;
	#50000; $finish;
end


always begin
 #5; clk = ~clk;
end

initial begin
$vcdplusfile("counter_two.vpd");
$vcdpluson(0, top);
end
counter_two(clk, rst, x, y);
endmodule
