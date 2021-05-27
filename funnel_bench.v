module top;
reg [7:0] i, s;
reg [2:0] f;
wire [7:0] o;

initial begin
    i = 8'b01010001;
    s = 8'b00000011;
    f = 3'b000;
    #100;
    i = 8'b10100011;
    s = 8'b00000010;
    f = 3'b001;
    #200;
end

/*
initial begin
$vcdplusfile("funnel.vpd");
$vcdpluson(0, top);
end
*/

initial begin
	$monitor("i = %8b, f = %8b, s = %8b, o = %8b", i,f,s,o);
end
funnel dut(i,f,s,o);

endmodule
