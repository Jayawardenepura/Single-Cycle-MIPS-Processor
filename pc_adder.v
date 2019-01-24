module pc_adder(pc_prev, pc_next);

parameter WIDHT = 32;

input   		[WIDHT-3:0]pc_prev;
output reg 	[WIDHT-3:0]pc_next;

always @(pc_prev) begin
    	pc_next <= pc_prev + 1'b1;
end

endmodule

