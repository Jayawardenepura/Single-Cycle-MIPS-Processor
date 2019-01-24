module mux2inputs_to_5bit(i_A, i_B, cnrtl, out);
input  		[4:0] i_A;
input   		[4:0] i_B;
input       cnrtl;

output reg	[4:0] out;

always@(*) begin
	out = (!cnrtl) ? i_A : i_B;
end

endmodule
