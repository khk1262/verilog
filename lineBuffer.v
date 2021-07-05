module lineBuffer(
input clk, 
input rst,
input csn, 
input wen,
input [3:0] ad,
input [15:0] din,
output [15:0] dout,
output reg state
);

reg [15:0] line [1026:0]; //line buffer
reg [10:0] wPtr;
reg [10:0] rPtr;

reg [10:0] temp_rPtr;

assign dout = line[temp_rPtr];

always@(posedge clk or posedge rst) begin
	if(rst == 1'b1) begin
		wPtr <= 'b0;
		rPtr <= 'b0;
		state <= 'b0;
	end
	else begin
		if(csn==1'b1) begin
			if(wen == 1'b1) begin
				if(wPtr == 1026) begin 
					if(state == 1'b0) begin
						state <= 1'b1;
						wPtr <= 'b0;
					end
					else wPtr <= 'b0;
				else wPtr <= wPtr + 1;
				line[wPtr] <= din;
			end

			if(rPtr == 1026) rPtr <= 'b0;
			else rPtr <= rPtr + 1;

			if(rPtr+ad > 1026) temp_rPtr <= rPtr+ad-1026
			else temp_rPtr <= rPtr+ad

		end				
	end
end

endmodule
