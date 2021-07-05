module top;
	reg rst, clk;
	reg i_en;
	reg[15:0] din;
	wire done;
	wire o_en;
	wire [19:0] result;

	reg[18:0] r_ad;
	reg[7:0] r_data[0:262143];
	reg[18:0] w_ad;
	reg[7:0] w_data[0:262143];
	
	reg[7:0] valid_data[0:262143];
	reg[18:0] v_ad;

	reg[5:0] cycle;



always begin
	#5; clk = ~clk;
end

initial begin
	$vcdplusfile("con_test_lb_pad.vpd");
	$vcdpluson(0, top);
end

initial begin
	clk = 1'b0;
	rst = 1'b0;
	i_en = 1'b0;
	r_ad = 1'b0;
	w_ad = 1'b0;
	v_ad = 1'b0;

	cycle = 5'b00000;
	$readmemh("img_hex.dat", r_data);
	$readmemh("valid_img2_pad.dat", valid_data);
	#3; rst = 1'b1;
	#27; rst = 1'b0;

	r_ad = 'b0;
	while(1) begin
		@(posedge clk);
		din = r_data[r_ad];
		i_en = 1'b1;
		@(posedge clk);
		din = 'bx;
		i_en = 1'b0;
		repeat(24) begin
			@(posedge clk);
		end
		if(r_ad < 262144) begin
			r_ad = r_ad + 1;
		end
	end
end

always@(posedge clk) begin
	if(rst == 1'b1) begin
		w_ad <= 1'b0;
		v_ad <= 1'b0;	
	end
	else begin
		if(o_en == 1'b1) begin
			if(valid_data[v_ad] == result) begin
				w_data[w_ad] <= result;
				w_ad <= w_ad + 1;
				v_ad <= v_ad + 1;
			end
			else $finish;
		end

		if(done == 1'b1) begin
			$writememh("img2_lb_pad.dat", w_data);
			$finish;
		end
	end
end
con_test_lb_pad u0(rst, clk, din, i_en, o_en, result, done);
endmodule
