`define memory 1026 
`define address 10	

module linebuffer(clk, csn, wen, a, din, dout);
	input clk, csn, wen;
	input [`address:0] a;
	input [15:0] din;
	output [15:0] dout;

	reg[15:0] data[0:`memory];
	reg[`address:0] a_reg;

	always@(posedge clk) begin
		if(csn==1'b0) begin
			if(wen==1'b1) data[a] <= din;
			a_reg<=a;
		end
	end
	assign dout = data[a_reg];
endmodule
