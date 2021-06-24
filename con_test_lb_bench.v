module top;
	reg rst, clk;
	reg i_en;
	reg[15:0] din;
	wire done;
	wire [19:0] result;

	reg[18:0] ad;
	reg[15:0] data[0:262144];
	reg[4:0] cycle;


initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
	ad = 1'b0;
	cycle = 4'b0000;
	$readmemh("img_hex.dat", data);
	#3; rst = 1'b1;
	#27; rst = 1'b0;
end

always begin
	#5; clk = ~clk;
end

initial begin
	$vcdplusfile("con_test_lb.vpd");
	$vcdpluson(0, top);
end


always@(posedge clk) begin
	if(rst == 1'b1) begin
		cycle <= 4'b0000;
		ad <= 1'b0;
	end
	else begin
		if(cycle == 4'b1111) begin
			cycle <= 4'b0000;
			if(ad < 262144) ad <= ad + 1;
			i_en <= 1'b1;
		end
		else begin
			cycle <= cycle + 1;
			i_en <= 1'b0;
		end 
	end

	din <= data[ad];

	if(done == 1'b1) begin
		$finish;
	end
end
con_test_lb u0(rst, clk, din, i_en, result, done);
endmodule
