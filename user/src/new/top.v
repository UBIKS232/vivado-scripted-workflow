/*
Simple UART
Input:
    rx
Output:
    tx
Internal signals:
    clk
*/
module top(
    input clk,
    input rst,
    input l2b,
    input oe,
    input rx,
    output [7:0]test
);

    hc595 u_hc595(
        .clk 	(clk  ),
        .l2b 	(l2b  ),
        .rst 	(rst  ),
        .ser 	(rx  ),
        .oe  	(oe   ),
        .pr  	(test   )
    );

endmodule

