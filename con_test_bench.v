module top;
	reg rst, clk;
	reg i_en;
	wire done;
	wire [19:0] result;

initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
	#5; rst = 1'b1;
	#5;
	rst = 1'b0;
	i_en = 1'b1;
	#7;
	i_en = 1'b0;	
	#50000000; $finish;
end

always begin
	#5; clk = ~clk;
end

initial begin
	$vcdplusfile("con_test.vpd");
	$vcdpluson(0, top);
end
counter_sram u0(rst, clk, result, i_en, done);

always@(posedge clk) begin
	if(done == 1'b1) begin
		$writememh("img2.dat", top.u0.u0.data);
	end
end
endmodule

