module mips(clk, reset);

input 		clk, reset; 

wire 			RegWrite;
wire		 	[31:0] pc_out; 
wire			[29:0] pc_in;
wire			[29:0] adder_in, adder_out;

wire 			[4:0]  read_register_RA, read_register_RB, read_register_RW;
wire			[31:0] instr_addr,instruction;
wire 			[31:0] BusW, bus_A_out, bus_B_out;

wire			[31:0] alu_A,alu_B,alu_result; /* alu */
wire			[4:0]  shift_amount;
wire			[3:0]	 alu_control;
wire					 o_flag_zero;

/* alu control */
wire			[5:0]  opcode, funct;
wire			[3:0]	 alu_control_unit;

wire			[4:0]  i_rt_mux, i_rd_mux, j_r_muxout; /* 1st mux */
wire					 RegDst;

wire 			[15:0] word2extend;	/* sing enxtend */
wire			[31:0] extended_word;
wire					 ExtOp;

wire			[31:0] extend, non_extend, mux32bit_to_alu; /* 2nd mux */
wire 					 ALUSrc;

wire			[31:0] i_datamem_addr, i_datamem_data,o_datamem_dataout;
wire					 MemWrite;

wire			[31:0] alu_path0, mem_path1, o_to_BusW; /* 3rd mux */
wire				 	 MemtoReg;

/* DC control */
wire     	[5:0]  i_opCode;
wire					 o_regDst;
wire     			 o_regWrite;
wire      			 o_jump;
wire      			 o_beq;
wire      			 o_bne;
wire      			 o_extOp;
wire      		 	 o_aluSrc;
wire      			 o_memWrite;
wire      			 o_memToReg;

/* Next PC for branches & jumps */
wire					 beg, bne, j, br_o_flag_zero;
wire			[29:0] inc_pc; 
wire			[25:0] imm26; 
wire					 pcsrc;
wire			[29:0] br_target;

wire			[29:0] br_sel0, br_sel1, next_instr; 
wire			sel_pc;

control_unit		 	control(i_opCode, 
										o_regDst, 
										o_regWrite, 
										o_jump, 
										o_beq, 
										o_bne, 
										o_extOp, 
										o_aluSrc, 
										o_memWrite, 
										o_memToReg);

pc_adder			 	 	adder(adder_in, adder_out);

program_counter	 	PC(pc_in, pc_out, 
								clk, reset);
								
instruction_mem 	 	instr_mem(instr_addr, instruction);

register_file 	    	reg_file(read_register_RA, read_register_RB, read_register_RW, 
										BusW, RegWrite,
										bus_A_out, bus_B_out,
										clk, reset);
ALU32Bit 		 		ALU(alu_A, alu_B,shift_amount, alu_result,
									alu_control,
									o_flag_zero);
									
alu_control				ALU_control(opcode, funct, alu_control_unit);
									
mux2inputs_to_5bit 	rt_rd_mux2_5(i_rt_mux, i_rd_mux, 
									RegDst, j_r_muxout);

sign_extension 	 	extendor(word2extend, extended_word, 
										ExtOp);

mux2inputs_to_32bit 	BUS_B_extend_mux2_32(non_extend, extend, 
									  ALUSrc, mux32bit_to_alu);

data_memory 			MEMORY(i_datamem_addr, i_datamem_data, 
										o_datamem_dataout,
										MemWrite, 
										clk);

mux2inputs_to_32bit 	alu_or_mem_mux2_5extreme(alu_path0, mem_path1, 
												MemtoReg, o_to_BusW);

Next_PC					NEXT_PC(beg, bne, j, br_o_flag_zero,
									 inc_pc, imm26, 
									 pcsrc, br_target);												

mux2inputs_to_30bit  brunch_mux(br_sel0 ,br_sel1, sel_pc, next_instr);
											
assign adder_in 			  = pc_out[31:2];

assign instr_addr 		  = pc_out;

/* in out of reg file assigments*/
assign read_register_RA   = instruction[25:21]; /* rs */
assign read_register_RB   = instruction[20:16]; /* rt */
assign i_rt_mux 			  = instruction[20:16]; /* rt */
assign read_register_RW   = j_r_muxout; 
assign i_rd_mux 			  = instruction[15:11]; /* rd */

assign alu_A				  = bus_A_out;
assign shift_amount		  = instruction[9:5];/* sa shift amount is connected into alu directly*/
assign word2extend 		  = instruction[15:0];

assign non_extend  		  = bus_B_out;
assign extend 				  = extended_word;
assign alu_B 				  = mux32bit_to_alu;

assign i_datamem_data 	  = bus_B_out;
assign alu_path0 		 	  = alu_result;
assign i_datamem_addr	  = alu_result;

assign mem_path1 		 	  = o_datamem_dataout;
assign BusW 				  = o_to_BusW;

assign i_opCode 			  = instruction[31:26]; 	

assign funct				  = extended_word[5:0];//instruction[5:0];
assign opcode 				  = i_opCode;
assign alu_control		  = alu_control_unit;	  
 
/* control decoder assigments*/
assign RegDst             = o_regDst;	
assign RegWrite           = o_regWrite; 
assign ExtOp              = o_extOp; 	
assign ALUSrc             = o_aluSrc; 	
assign MemWrite           = o_memWrite; 
assign MemtoReg           = o_memToReg; 

/* jump,branch handler assigments*/
assign j						  = o_jump; 
assign beg					  = o_beq; 
assign bne					  = o_bne;
 
assign br_o_flag_zero	  = o_flag_zero;

assign br_sel0 			  = adder_out;
assign br_sel1 			  = br_target;
assign sel_pc  			  = pcsrc;


assign inc_pc				  = adder_out;
assign imm26				  = instruction[25:0];
assign pc_in 				  = next_instr;


endmodule
