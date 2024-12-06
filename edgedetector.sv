// File name:   edge_detector.sv
// Created:     4/16/2015
// Author:      John Skubic
// Version:     1.0 
// Description: Edge detector, added to socetlib by Cole Nelson 8/14/22 
//	

module edgedetector #(
    parameter WIDTH = 1
)
(
    edgedetector_if.edgedet edge_if
    // input logic CLK, nRST, 
    // input logic [WIDTH - 1:0] signal,
    // output logic [WIDTH - 1:0] pos_edge, neg_edge
);

    //logic [WIDTH - 1 : 0] signal_r;

    //flip flop behavior
    always_ff @ (posedge edge_if.clk, negedge edge_if.n_rst) begin
        if(~(edge_if.n_rst))
            edge_if.signal_r <= '0;
        else 
            edge_if.signal_r <= edge_if.signal;
    end

    //output logic
    assign edge_if.pos_edge = edge_if.signal & ~edge_if.signal_r;
    assign edge_if.neg_edge = ~edge_if.signal & edge_if.signal_r;

endmodule
