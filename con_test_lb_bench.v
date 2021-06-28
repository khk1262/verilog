module top;
	reg rst, clk;
	reg i_en;
	reg[15:0] din;
	wire done;
	wire o_en;
	wire [19:0] result;

	reg[18:0] r_ad;
	reg[15:0] r_data[0:262144];
	reg[18:0] w_ad;
	reg[7:0] w_data[0:260099];
	reg[5:0] cycle;


initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
	r_ad = 1'b0;
	w_ad = 1'b0;
	cycle = 5'b00000;
	$readmemh("img_hex.dat", r_data);
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
		cycle <= 5'b00000;
		r_ad <= 1'b0;
		w_ad <= 1'b0;
	end
	else begin
		if(cycle == 5'b11000) begin
			cycle <= 5'b00000;
			if(r_ad < 262144) r_ad <= r_ad + 1;
			i_en <= 1'b1;
		end
		else begin
			cycle <= cycle + 1;
			i_en <= 1'b0;
		end 
	end

	din <= r_data[r_ad];
	
	if(o_en == 1'b1) begin
		w_data[w_ad] <= result;
		w_ad <= w_ad + 1;
	end

	if(done == 1'b1) begin
		$writememh("img2_lb.dat", w_data);
		$finish;
	end
end
con_test_lb u0(rst, clk, din, i_en, o_en, result, done);
endmodule
