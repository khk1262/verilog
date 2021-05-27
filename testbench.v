module top;
reg [3:0] a,b;
wire [3:0] s;

initial begin
a = 4'b0;
b=4'b0;
#100;
a=4'b0101;
b=4'b1000;
#200;
a=4'b1000;
b= 4'b1010;
#200;

end

initial begin
//	$monitor(a,b,s);
$vcdplusfile("add4.vpd");
$vcdpluson(0,top);
end

add4 dut(a,b,s);
endmodule
