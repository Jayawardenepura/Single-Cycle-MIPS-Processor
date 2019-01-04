module ALU32Bit(i_A, i_B, i_Shift_amount, o_ALU_result, i_ALUCtrl, o_flag_zero);

input					[3:0] i_ALUCtrl;

input signed 		[31:0] i_A;
input 				[31:0] i_B;	   
input					[4:0] i_Shift_amount;

output  reg 		[31:0] o_ALU_result;	
output  reg  		o_flag_zero;	   

reg 					[3:0] AND,OR,NOR,XOR;
reg 					[3:0] ADD,SUB;
reg 					[3:0] SLL,SRL,SRA;

initial begin	
	/* Alu selection('10') + Arifmetic operation */
	ADD  = 4'b1000;
	SUB  = 4'b1001;

	/* Alu selection('11') + Logical operation */
	AND  = 4'b1100;
	OR   = 4'b1101;
	NOR  = 4'b1110;
	XOR  = 4'b1111;
	
	/* Alu selection('00') + Shift type operation*/
	SLL  = 4'b0000;
	SRL  = 4'b0001;
	SRA  = 4'b0010;
end
	
always @* begin
casez (i_ALUCtrl)

	/* arithmetic */
	ADD: o_ALU_result = i_A + i_B;
	SUB: o_ALU_result = i_A + (~i_B + 1);
	
	/* logical */
	AND: o_ALU_result = i_A & i_B;
	OR:  o_ALU_result = i_A | i_B;
	NOR: o_ALU_result = ~(i_A | i_B);
	XOR: o_ALU_result = i_A^i_B;
	
	/* shifts */
	SLL: o_ALU_result = i_A << (i_Shift_amount);
	SRL: o_ALU_result = i_A >> (i_Shift_amount);
	SRA: o_ALU_result = i_A >>> (i_Shift_amount);
 	
	default: begin
			o_ALU_result = 32'hz;
		end
endcase
end

always @(o_ALU_result)
	o_flag_zero = (o_ALU_result == 32'h0) ? 1'b1 : 1'b0;

endmodule

