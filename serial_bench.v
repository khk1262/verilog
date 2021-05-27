module top;
	reg load, clk;
	reg [7:0] in;
	wire out;
	wire out_en;

initial begin
	clk = 1'b0;
	load = 1'b0;
	#5; load = 1'b1;
	#5; load = 1'b0;
	#115; load = 1'b1;
	#5; load = 1'b0;
	#1000;
end
always begin
	#5; clk = ~clk;
end

initial begin
	in = 8'b0;
	#5;
	in = 8'b01101110;
	#90;
	in = 8'b10011011;
	#160;
	$finish;
end

initial begin
$vcdplusfile("serial.vpd");
$vcdpluson(0,top);
end
serializer(load, clk, in, out, out_en);
endmodule
