module program_counter(next_address, address, i_clk, i_arstn);

parameter WIDHT = 32;

input 		i_clk,i_arstn;
input 		[WIDHT-3:0] next_address; 
output 	 	[WIDHT-1:0] address;

reg 			[29:0] pc;

always @(posedge i_clk,negedge i_arstn) begin
	if(!i_arstn) begin
		pc <= 30'h0;
	end else begin
		pc <= next_address;
	end
end

/* The address of the next instruction*/
assign address={pc,2'b00}; 

endmodule 