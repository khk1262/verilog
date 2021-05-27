module funnel(i, f, s, o);
input [7:0] i;
input [7:0] s;
input [2:0] f;
output [7:0] o;

wire [15:0] c;

assign c = (f==3'b000) ? {8'b0, i[7:0]} >> s :
	(f==3'b001) ? {i[7:0], 8'b0} >> (8-s):
	(f==3'b010) ? {{8{i[7]}}, i[7:0]} >> s:
	(f==3'b011) ? {i[7:0], 8'b0} >> (8-s):
	(f==3'b100) ? {i[7:0], i[7:0]} >> s:
	{i[7:0], i[7:0]} >> (8-s);

/*
case(f)
    3'b000: assign c = {8'b0, i[7:0]} << s;
    3'b001: assign c = {i[7:0], 8'b0} << (8-s);
    3'b010: assign c = {{8{i[7]}}, i[7:0]} << s;
    3'b011: assign c = {i[7:0], 8'b0} << (8-s);
    3'b100: assign c = {i[7:0], i[7:0]} << s;
    3'b101: assign c = {i[7:0], i[7:0]} << (8-s);
endcase
*/
assign o = c[7:0];

endmodule 


