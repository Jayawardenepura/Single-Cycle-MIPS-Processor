module gpio (i_Data,o_Data, i_clk, i_we_dir, i_we_dout,read, i_din_feedback, i_ddir_feedback);

input [31:0] i_Data;
input i_we_dout,i_we_dir;
//output [31:0] i_din_feedback;
//output i_ddir_feedback;
input i_clk;

output [31:0] read;
output [31:0] i_din_feedback,i_ddir_feedback;

inout  [31:0] o_Data;

reg 	 [31:0] DOUT;
reg 	 [31:0] DIN;
reg 	 [31:0] DDIR;

always @(posedge i_clk) begin
	if(i_we_dir) begin
		DDIR <= i_Data;/* 0 - read */
	end
end

assign i_ddir_feedback = DDIR;
assign i_din_feedback = DIN;
genvar i;
generate
	for (i = 0; i < 32; i = i + 1) begin: tri_state
		assign o_Data[i] = DDIR[i] ? DOUT[i] : 1'bz;
	end
endgenerate
assign read = DIN;

always @(posedge i_clk) begin 
	if(i_we_dout) begin 
		DOUT <= i_Data;
	end
end

always @(posedge i_clk) begin
		DIN <= o_Data;
end
		
endmodule
