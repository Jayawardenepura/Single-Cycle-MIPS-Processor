module Next_PC(i_beq, i_bne, i_j, i_zero, i_incPc, i_Imm26, o_PCSrc, o_target);

input 					 i_beq, i_bne, i_j, i_zero;
input 			[29:0] i_incPc;
input 			[25:0] i_Imm26;

output reg				 o_PCSrc;
output reg		[29:0] o_target;

wire 				[29:0] addr;
wire				[29:0] extenstion;
wire				[15:0] imm_word;

assign imm_word 		= i_Imm26[15:0];
assign extenstion 	= {{(14){imm_word[15]}},imm_word}; //; ? {14'b1, imm_word} : {14'b0, imm_word};
assign addr			 	= i_incPc + extenstion;

assign src = ((~i_zero) & i_bne) | (i_zero & i_beq) | i_j; 

always @* begin
	o_PCSrc <= src; 
end

always @* begin
if (i_j) begin 
		o_target = {i_incPc[29:26], i_Imm26};
	end else begin
		o_target = addr;
	end 
end

endmodule 