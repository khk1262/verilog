`define address 18

module top;
	reg clk, csn, wen;
	reg [`address:0] a;
	wire[15:0]  din, dout;

initial begin
	clk = 1'b0;
	csn = 1'b0;
	wen = 1'b0;
	a = 'b0;
	din = 1'b0;
	#5;
	csn = 1'b1; 
	a = 19'b0000000000000000001;
	#20; csn = 1'b0;
	#5; 
	csn = 1'b1;
	a = 5;
	#20; csn = 1'b0;
	#5; 
	csn = 1'b1;
	a = 19'b0000000000001000011;
	#300; $finish;
end

always begin
	#5; clk = ~clk;
end

initial begin
$vcdplusfile("mem_test.vpd");
$vcdpluson(0, top);
end
sram(clk, csn, wen, a, din, dout);
endmodule

