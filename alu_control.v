module alu_control(i_opcode, i_funct, o_alu_func);

input 		 [5:0] i_opcode,i_funct;
output reg 	 [3:0] o_alu_func;

reg 			 [11:0] control;

always @* begin
	control = {i_opcode, i_funct};
end

always @* begin
	casez (control)
			/* ADD */
			12'b000000100000: begin
				o_alu_func = 4'b1000;
			
			end 
			
			/* ADDI Add Immediate*/
			12'b001000??????: begin
				o_alu_func = 4'b1000;
			end
			
			/* SUB Subtract*/
			12'b000000100010: begin
				o_alu_func = 4'b1001;
			end
			
			/* AND */
			12'b000000100100: begin
				o_alu_func = 4'b1100;
			end
			
			/* ANDI */
			12'b001100??????: begin
				o_alu_func = 4'b1100;
			end
			
			/* OR */
			12'b000000100101: begin
				o_alu_func = 4'b1101;	
			end
			
			/* ORI */
			12'b001101??????: begin
				o_alu_func = 4'b1101;	
			end
			
			/* NOR */
			12'b000000100111: begin
				o_alu_func = 4'b1110;	
			end
			
			/* XOR Exclusive Or*/
			12'b000000100110: begin
				o_alu_func = 4'b1111;	
			end
			
			/* XORI Exclusive Or Immediate*/
			12'b001110??????: begin
				o_alu_func = 4'b1111;	
			end
			
			/* SLL Shift Left Logical*/
			12'b000000000000: begin
				o_alu_func = 4'b0000;	
			end
			
			/* SRL Shift Right Logical*/
			12'b000000000010: begin
				o_alu_func = 4'b0001;
			end
			
			/* SRA Shift Right Arithmetic*/
			12'b000000000011: begin
				o_alu_func = 4'b0010;
			end
			
			/* BNE Branch On Not Equal*/
			12'b000101??????: begin
				o_alu_func = 4'b1001; //<- SUB A-B compare
			end
						
			/* BEQ */
			12'b000100??????: begin
				o_alu_func = 4'b1001; 
			end
			
			/* J jump */
			12'b000010??????: begin
				o_alu_func = 4'bx; 
			end
			
			/* LW */
			12'b100011??????: begin
				o_alu_func = 4'b1000;//<- ADD immediate16+base
			end
			
			/* SW */
			12'b101011??????: begin
				o_alu_func = 4'b1000;
			end


			default: begin
				o_alu_func = 4'bx;
			end
	endcase
end

endmodule
