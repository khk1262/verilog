`define memory 524288
`define address 18	

module sram(clk, csn, wen, a, din, dout, store);
	input clk, csn, wen;
	input [`address:0] a;
	input [15:0] din;
	output [15:0] dout;
	input store;

	reg[15:0] data[0:`memory];
	reg[`address:0] a_reg;

	initial begin
		$readmemh("img.dat", data);
	end

	always@(posedge clk) begin
		if(csn==1'b0) begin
			if(wen==1'b1) data[a] <= din;
			a_reg<=a;
		end
		if(store == 1'b1)
			$writememh("img2.dat", data);
	end
	assign dout = data[a_reg];
endmodule
