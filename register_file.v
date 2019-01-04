module register_file(i_RA,i_RB,
							i_RW,BUS_W,
							i_WE,
							o_BUS_A,o_BUS_B,
							i_clk,i_arstn);

input		 	 [4:0]  i_RA, i_RB, i_RW;
input 		 		  i_WE, i_clk, i_arstn;
input 		 [31:0] BUS_W;

output reg	 [31:0] o_BUS_A,o_BUS_B;

/* 32 bit 32 registers */
reg [31:0] sram_mem [31:0];

integer s_cell;
always @(posedge i_clk,negedge i_arstn) begin
	if(!i_arstn) begin
		for(s_cell = 0; s_cell < 32; s_cell = s_cell + 1)
			sram_mem[s_cell] = 32'h0;
	end else if(i_WE) begin
		sram_mem[i_RW] <= BUS_W;
	end
end


/* simultaneously broadcasting */
always @(posedge i_clk,negedge i_arstn) begin
	if(!i_arstn) begin
		o_BUS_A <= 0;
	end else begin
		o_BUS_A <= sram_mem[i_RA];
	end
end
		
always @(posedge i_clk,negedge i_arstn) begin
	if(!i_arstn) begin
		o_BUS_B <= 0;
	end else begin
		o_BUS_B <= sram_mem[i_RB];
	end
end

endmodule

