module ex1(a,b,c,f);
input a,b,c;
output f;

assign f = (c==1'b0) ? ~a&b : 1'b1;

endmodule
