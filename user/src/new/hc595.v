/*
Serial to Parallel module,  based on TI-sn74hc595
Input:
    ser     serial          1bit
    clk     serial clock    1bit
    l2b     load to buffer  1bit
    rst     reset           1bit
    oe      output enable   1bit
Output:
    pr      parallel        8bit
Register:
    sft     shift reg       8bit
    stg     stage reg       8bit
*/
module hc595(
        input clk,
        input l2b,
        input rst,
        input ser,
        input oe,
        output [7:0]pr
    );

    reg [7:0]sft;
    reg [7:0]stg;

    always @(posedge rst) begin
            sft<=8'b0;
            stg<=8'b0;
    end
    always @(posedge clk) begin
            sft<={sft[7:1],ser};
    end
    always @(posedge l2b) begin
        stg<=sft;
    end

    assign pr=(oe==1)?8'bzzzzzzzz:stg;

endmodule
