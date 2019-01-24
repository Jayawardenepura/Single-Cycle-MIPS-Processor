module control_unit(
input       [5:0] i_opCode,
output reg        o_regDst,
output reg        o_regWrite,
output reg        o_jump,
output reg        o_br_beq,
output reg        o_br_bne,
output reg        o_extOp,
output reg        o_aluSrc,
output reg        o_memWrite,
output reg        o_memToReg
  );

reg [5:0] OP_RTYPE;		
reg [5:0] OP_ADDI; 		
reg [5:0] OP_ADDIU; 	
reg [5:0] OP_SLTI; 		
reg [5:0] OP_ANDI; 		
reg [5:0] OP_ORI; 		
reg [5:0] OP_XORI;		
reg [5:0] OP_J;			
reg [5:0] OP_BEQ; 		
reg [5:0] OP_BNE; 		
reg [5:0] OP_LW; 		
reg [5:0] OP_SW; 		

initial begin
OP_RTYPE 	=	6'b000000;
OP_ADDI 		= 	6'b001000;
OP_ADDIU 	= 	6'b001001;
OP_SLTI 		= 	6'b001010;
OP_ANDI 		= 	6'b001100;
OP_ORI 		= 	6'b001101;
OP_XORI 		= 	6'b001110;
OP_J 			= 	6'b000010;
OP_BEQ 		= 	6'b000100;
OP_BNE 		= 	6'b000101;
OP_LW 		= 	6'b100011;
OP_SW 		= 	6'b101011;
end

always @(i_opCode) begin
  // Default values placeholder
    o_br_beq    = 1'b0;
    o_br_bne    = 1'b0;
    o_jump      = 1'b0;
    o_memWrite  = 1'b0;
  // Match logic
  casez(i_opCode)
    // R-type common instructions
    OP_RTYPE  : begin                  
                  o_regDst    = 1'b1; // 1: RW<=Rd
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'bx; // dont care
                  o_aluSrc    = 1'b0; // 0: ALU_B<=BusB
                  o_memToReg  = 1'b0; // 0: BusW<=ALU_i_sel
                end
                
    // I-type instructions
    OP_ADDI   : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b1; // 0: zero; 1: sign
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0: BusW<=ALU_i_sel
                end
                
    OP_ADDIU  : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b0; // 0: zero
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0: BusW<=ALU_i_sel
                end
                
    OP_SLTI   : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b1; // 1: sign
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0:BusW<=ALU_i_sel
                end
                
    OP_ANDI   : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b0; // 0: zero
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0:BusW<=ALU_i_sel
                end
                
    OP_ORI    : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b0; // 0: zero
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0:BusW<=ALU_i_sel
                end
                
    OP_XORI   : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b0; // 0: zero
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b0; // 0: BusW<=ALU_i_sel
                end
                
    // Special instructions
    OP_J      : begin
                  o_jump      = 1'b1;
                  
                  o_regDst    = 1'bx; // RW<= dont care
                  o_regWrite  = 1'b0; // 0: No write
                  o_extOp     = 1'bx; // dont care
                  o_aluSrc    = 1'bx; // ALU_B<= dont care
                  o_memToReg  = 1'bx; // BusW<= dont care
                end
                
    OP_BEQ    : begin
                  o_br_beq    = 1'b1;
                                    
                  o_regDst    = 1'bx; // RW<= dont care
                  o_regWrite  = 1'b0; // 0: No write
                  o_extOp     = 1'bx; // dont care
                  o_aluSrc    = 1'b0; // 0: ALU_B<=BusB
                  o_memToReg  = 1'bx; // BusW<= dont care
                end
                
    OP_BNE    : begin
                  o_br_bne    = 1'b1;
                  
                  o_regDst    = 1'bx; // RW<= dont care
                  o_regWrite  = 1'b0; // 0: No write
                  o_extOp     = 1'bx; // dont care
                  o_aluSrc    = 1'b0; // 0: ALU_B<=BusB

                  o_memToReg  = 1'bx; // BusW<= dont care
                end
                
    OP_LW     : begin
                  o_regDst    = 1'b0; // 0: RW<=Rt
                  o_regWrite  = 1'b1; // 1: Write RW
                  o_extOp     = 1'b1; // 0: zero; 1: sign
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'b1; // 1: BusW<=MEM_i_sel
                end
                
    OP_SW     : begin
                  o_memWrite  = 1'b1;
                  o_regDst    = 1'bx; // RW<= dont care
                  o_regWrite  = 1'b0; // 0: No write
                  o_extOp     = 1'b1; // 1: sign
                  o_aluSrc    = 1'b1; // 1: ALU_B<=Imm
                  o_memToReg  = 1'bx; // BusW<= dont care
                end
                
    // No match placeholder
    default   : begin
                  // Set all as X - 
                  // error visible during simultaion,
                  // full case during synthesis.
                  o_regDst    = 1'bx;
                  o_regWrite  = 1'bx;
                  o_jump      = 1'bx;
                  o_br_beq    = 1'bx;
                  o_br_bne    = 1'bx;
                  o_extOp     = 1'bx;
                  o_aluSrc    = 1'bx;
                  o_memWrite  = 1'bx;
                  o_memToReg  = 1'bx;
                end
    
  endcase
end

endmodule