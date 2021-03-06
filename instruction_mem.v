`define ROM_FILE  "firmware/bubblesort.bin" /* here the main path to binary file */

`ifndef __ROM__
`define __ROM__
module instruction_mem(i_addr, o_data);
parameter DATA_WIDTH=32, ADDR_WIDTH=32;
parameter ROM_BLOCKS_NUM = 256;
parameter [DATA_WIDTH-1:0] ROM_DEFLT_DATA = {DATA_WIDTH{1'b0}};
localparam [ADDR_WIDTH-1:0] ROM_END_ADDR   = ROM_BLOCKS_NUM*ADDR_WIDTH;

input [ADDR_WIDTH-1:0] i_addr;
output [DATA_WIDTH-1:0] o_data;

// Module description below
reg [DATA_WIDTH-1:0] o_data;
reg [DATA_WIDTH-1:0] rom_mem [0:ROM_BLOCKS_NUM-1];

// load memory contents from file
initial begin : INIT
  integer i;
  for (i=0; i<ROM_BLOCKS_NUM; i=i+1) begin
    rom_mem[i] = ROM_DEFLT_DATA;
  end
	/* change $readmemb(FILE, mem) to
	   readmemh(..) if your binary is presented in hex
	*/
 // $readmemh(`ROM_FILE, rom_mem);
  $readmemb(`ROM_FILE, rom_mem);
end

// read logic
always @(i_addr) begin
  if (i_addr > ROM_END_ADDR) 
          o_data = ROM_DEFLT_DATA;
  else
          o_data = rom_mem[i_addr];
end

endmodule
`endif
