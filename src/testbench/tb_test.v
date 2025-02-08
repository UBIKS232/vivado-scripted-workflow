`timescale 1ns / 1ps

module tb_test;
    reg a;
    wire b;

    initial begin
        $dumpfile("./proj/build/tb_test.vcd");
        $dumpvars(0,tb_test);
    end

    initial begin
        a <= 1'b0;
        #100;
        a <= 1'b1;
        #100;
        a <= 1'b0;
        #100;
        a <= 1'b1;
        #100;
        $stop;
    end

    test dut(
        .a(a),
        .b(b)
    );

endmodule


