module mips(clk, reset);

input 		clk, reset; 

wire		 	[31:0] 	pc_out; 
wire			[29:0] 	pc_in;
wire			[29:0] 	adder_in, adder_out;

wire 						i_RegWrite;
wire			[4:0]		i_reg_R_aaddr, i_reg_R_baddr, i_reg_R_wdata;
wire			[31:0]	instr_addr,instruction;
wire 			[31:0]	i_reg_BusW_data, o_bus_A_out, o_bus_B_out;

wire			[31:0] alu_A,alu_B,alu_result; /* alu */
wire			[4:0]  shift_amount;
wire			[3:0]	 alu_control;
wire					 o_flag_zero;

/* alu control */
wire			[5:0]  opcode, funct;
wire			[3:0]	 alu_control_unit;

wire			[4:0]  i_rt_mux, i_rd_mux, j_r_muxout; 
wire					 i_RegDst;

wire 			[15:0] word2extend;	
wire			[31:0] extended_word;
wire					 i_ExtOp;

wire			[31:0] extend, non_extend, mux32bit_to_alu; 
wire					 i_ALUSrc;

wire			[31:0] i_datamem_addr, i_datamem_data,o_memdata;
wire					 i_MemWrite;

wire			[31:0] alu_path0, mem_path1, o_to_BusW; 
wire					 i_MemtoReg;

/* Control signals*/
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

/* branches & jumps zone*/
wire					 	i_beq, i_bne, i_j, br_o_flag_zero;
wire			[29:0] 	inc_pc; 
wire			[25:0] 	imm26; 
wire						PCSrc;
wire			[29:0] 	br_target;

wire			[29:0]	br_sel0, br_sel1, next_instr; 
wire						sel_pc;

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

pc_adder					adder(adder_in, adder_out);

program_counter		PC(pc_in, pc_out, 
								clk, reset);
								
instruction_mem		instr_mem(instr_addr, instruction);

register_file			register_file(i_reg_R_aaddr, i_reg_R_baddr, 
												i_reg_R_wdata, i_reg_BusW_data,
												o_bus_A_out, o_bus_B_out,
												i_RegWrite,clk);
										
ALU32Bit					ALU(alu_A, alu_B,shift_amount, alu_result,
									alu_control,
									o_flag_zero);
									
alu_control				ALU_control(opcode, funct, alu_control_unit);
									
mux2inputs_to_5bit	mux_R_J_select(i_rt_mux, i_rd_mux, 
									i_RegDst, j_r_muxout);

sign_extension			extend_word(word2extend, extended_word, 
									i_ExtOp);

mux2inputs_to_32bit	BUS_B_extend_mux2_32(non_extend, extend, 
									  i_ALUSrc, mux32bit_to_alu);

data_memory				memory(i_datamem_addr, i_datamem_data, 
										o_memdata,
										i_MemWrite, 
										clk);

mux2inputs_to_32bit	mux_to_BUS_wdata(alu_path0, mem_path1, 
												i_MemtoReg, o_to_BusW);

Next_PC					NEXT_PC(i_beq, i_bne, i_j, br_o_flag_zero,
									 inc_pc, imm26, 
									 PCSrc, br_target);												

mux2inputs_to_30bit	brunch_mux(br_sel0 ,br_sel1, sel_pc, next_instr);
											
assign adder_in				= pc_out[31:2];
assign instr_addr				= pc_out;

/* in out of reg file assigments*/
assign i_reg_R_aaddr			= instruction[25:21]; /* rs */
assign i_reg_R_baddr			= instruction[20:16]; /* rt */
assign i_rt_mux				= instruction[20:16]; /* rt */
assign i_reg_R_wdata			= j_r_muxout; 
assign i_rd_mux				= instruction[15:11]; /* rd */

assign alu_A					= o_bus_A_out;
assign shift_amount			= instruction[9:5];/* sa shift amount is connected into alu directly*/
assign word2extend			= instruction[15:0];

assign non_extend				= o_bus_B_out;
assign extend					= extended_word;
assign alu_B					= mux32bit_to_alu;

assign i_datamem_data		= o_bus_B_out;
assign alu_path0				= alu_result;
assign i_datamem_addr		= alu_result;

assign mem_path1				= o_memdata;
assign i_reg_BusW_data		= o_to_BusW;

assign i_opCode				= instruction[31:26]; 	

assign funct					= extended_word[5:0];//instruction[5:0];
assign opcode					= i_opCode;
assign alu_control			= alu_control_unit;	  
 
/* control decoder assigments*/
assign i_RegDst				= o_regDst;	
assign i_RegWrite				= o_regWrite; 
assign i_ExtOp					= o_extOp; 	
assign i_ALUSrc				= o_aluSrc; 	
assign i_MemWrite				= o_memWrite; 
assign i_MemtoReg				= o_memToReg; 

/* jump & branch handler assigments*/
assign i_j							= o_jump; 
assign i_beq						= o_beq; 
assign i_bne						= o_bne;
 
assign br_o_flag_zero		= o_flag_zero;

assign br_sel0					= adder_out;
assign br_sel1					= br_target;
assign sel_pc					= PCSrc;

assign inc_pc					= adder_out;
assign imm26					= instruction[25:0];
assign pc_in					= next_instr;

endmodule
