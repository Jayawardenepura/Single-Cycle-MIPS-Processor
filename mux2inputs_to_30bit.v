module mux2inputs_to_30bit(i_A, i_B, cnrtl, out);
input  		[29:0] i_A;
input			[29:0] i_B;
input       cnrtl;

output reg	[29:0] out;

/* Fill in the implementation here ... */ 
always@* begin
	out = (!cnrtl) ? i_A : i_B;
end

endmodule
