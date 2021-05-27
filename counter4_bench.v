module top;
	reg clk, rst;
	wire [3:0] o;

initial begin
	clk = 1'b0;
	rst = 1'b0;
	#5; rst = 1'b1;
	#20; rst = 1'b0;
	#400; $finish;
end

always begin
	#10; clk = ~clk;
end
initial begin
	$vcdplusfile("counter4.vpd");
	$vcdpluson(0,top);
end

counter4 dut(clk, rst, o);
endmodule
