module top;
	reg rst, clk;
	reg i_en;
	wire o_en;
	wire [15:0] din, dout;
	wire [19:0] result;

initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
	#5; rst = 1'b1;
	#5;
	rst = 1'b0;
	i_en = 1'b1;
	#5;
	i_en = 1'b0;	
	#50000000; $finish;
end

always begin
	#5; clk = ~clk;
end

initial begin
	$vcdplusfile("mem_test3.vpd");
	$vcdpluson(0, top);
end
counter_sram u0(rst, clk, din, dout, result, i_en, o_en);
endmodule

