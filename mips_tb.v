`timescale 1ns / 1ps

module testbench;

parameter PERIOD = 20;

reg i_clk,i_rst;
mips 		 	proc(
			.clk(i_clk),
			.reset(i_rst)
		        );

//initial begin

//end

initial begin
    i_clk = 0;
    forever #(PERIOD/2) i_clk = ~i_clk;
end

initial begin
    i_rst = 1'b0;

    @(negedge i_clk) i_rst = 1;
    
    i_rst = 1'b0;

    @(negedge i_clk) i_rst = 1;

    //repeat (50) @(negedge clk);    
    repeat (32) @(posedge i_clk);

    $stop;
end
  
endmodule
