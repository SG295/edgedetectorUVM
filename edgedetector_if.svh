`ifndef EDGEDETECTOR_IF_SVH
`define EDGEDETECTOR_IF_SVH

interface edgedetector_if #(parameter WIDTH = 1) (input logic clk);
  logic n_rst;

  logic [WIDTH - 1:0] signal;
  logic [WIDTH - 1:0] pos_edge, neg_edge;
  
  // logic check = 1;

  modport tester
  (
    input pos_edge, neg_edge, clk,
    output n_rst, signal
  );

  modport edgedet
  (
    output pos_edge, neg_edge,
    input n_rst, signal, clk
  );
endinterface

`endif
