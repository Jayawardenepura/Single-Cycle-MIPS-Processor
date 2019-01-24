module mux2inputs_to_32bit(i_A, i_B, i_sel, o_muxout);
parameter NBITS = 32;
input  		[NBITS-1:0] i_A;
input			[NBITS-1:0] i_B;
input       i_sel;

output reg	[NBITS-1:0] o_muxout;

always@* begin
		o_muxout = (!i_sel) ? i_A : i_B;
end

endmodule
