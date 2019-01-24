module data_memory(i_addr,i_data,o_data,i_memwr,i_clk);

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 7; 

localparam RAM_DEPTH = 2**ADDR_WIDTH;

input				[DATA_WIDTH-1:0] i_addr;
input				[DATA_WIDTH-1:0] i_data;
input 					 			i_memwr;
input 					 			i_clk;

output   		[DATA_WIDTH-1:0] o_data; 

reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

assign o_data = (!i_memwr) ? ram [i_addr] : 0;

/* write to memory */
always @(posedge i_clk) begin
	if(i_memwr) begin 
		ram[i_addr] <= i_data;
	end
end

endmodule
