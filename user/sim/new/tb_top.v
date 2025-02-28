`timescale 1ns / 1ps
`define clock_cycle 1

module tb_top;

    /*iverilog */
    initial begin
        $dumpfile("./prj/icarus/wave.vcd");
        $dumpvars(0, tb_top);
    end
    /*iverilog */

    reg clk;
    reg rst;
    // always #(`clock_cycle) clk<=~clk;

    reg rx;
    reg oe;
    reg l2b;

    wire [7:0]test;

    initial begin
        clk<=0;
        rst<=0;
        rx<=0;
        oe<=0;
        l2b<=0;

        #50 rx<=0;
        #50 rx<=1;
        #50 rx<=0;
        #50 l2b<=1;
        #200
        #50 l2b<=0;
        #50 rx<=1;
        #50 rx<=0;
        #50 rx<=1;
        #50 rx<=1;
        #50 rx<=1;
        #50 oe<=1;

        #200 $finish;
    end

    top u_top(
        .clk  	(clk   ),
        .rst  	(rst   ),
        .l2b  	(l2b   ),
        .oe   	(oe    ),
        .rx   	(rx    ),
        .test 	(test  )
    );

endmodule

