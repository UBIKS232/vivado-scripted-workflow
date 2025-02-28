`timescale 1ns / 1ps

module tb_top();

/*iverilog */
initial
begin
	umpfile(tb_top.vcd);
	umpvars(0, tb_top);
end
/*iverilog */
endmodule

