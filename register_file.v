module register_file(i_RA_addr,i_RB_addr,
							i_RW_addr,i_BusW_data,
							o_BusA_data,o_BusB_data,
							i_we,i_clk);

							
input 		 		  i_we, i_clk;
input		 	 [4:0]  i_RA_addr, i_RB_addr, i_RW_addr;
input 		 [31:0] i_BusW_data;

output wire	 [31:0] o_BusA_data,o_BusB_data;

/* 4 byte RAM memory */
reg [31:0] mem32_32 [31:0];

/* 
	cells initialization for obtaining a valid access 
	to the memory after address calculating
	
	Example:
	Without initialization: 
	 cell is empty -> data bit = x state -> ALU_ADD(x+12) = x -> invalid address
	With initializtation
	 cell is empty -> data bit = 0 -> ALU_ADD(0+12) = 12 -> valid address
*/
integer mem_cell;
initial begin
	for(mem_cell = 0; mem_cell < 32; mem_cell = mem_cell + 1)
		mem32_32[mem_cell] = 32'h0;
end

always @(posedge i_clk) begin
    if (i_we) begin
        mem32_32[i_RW_addr] <= i_BusW_data;
    end
end

/* have a valid data after access time */
assign o_BusA_data = mem32_32[i_RA_addr];
assign o_BusB_data = mem32_32[i_RB_addr];

endmodule

