module sign_extension(i_word, o_extended_word, i_SIGH);

 /* A 16-Bit input word */
 input 		[15:0] i_word;
 input 				 i_SIGH;

 /* A 32-Bit extended output word */
 output reg [31:0] o_extended_word;    

 always@*
	o_extended_word = (i_word[15] || i_SIGH) ? {16'hffff, i_word} : {16'h0000, i_word};
endmodule
