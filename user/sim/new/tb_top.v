`timescale 1ns / 1ps

module tb_top;
    /*iverilog */
    initial
    begin
        $dumpfile("./prj/icarus/tb_top.vcd");
        $dumpvars(0, tb_top);
    end
    /*iverilog */

    reg clk;
    reg rst;
    always #1 clk <= ~clk;

    initial begin



        #200 $finish;
    end

endmodule

