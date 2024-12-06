import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

class predictor extends uvm_subscriber#(transaction);
  `uvm_component_utils(predictor)

  uvm_analysis_port#(transaction) pred_ap;
  transaction output_tx;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    pred_ap = new("pred_ap", this);
  endfunction

  function void write(transaction t);
    output_tx = transaction#(4)::type_id::create("output_tx", this);
    output_tx.copy(t);

    registered_signals.copy(t); // use to make a "sizeof" copy, just need signal!

    always_ff @ (posedge t.clk, negedge t.n_rst) begin
      if(~(t.n_rst)) begin
        registered_signals.signal <= '0;
      end else begin
        registered_signals.signal <= t.signal;
      end
    end

    // calculate expected sum and expected overflow
    output_tx.pos_edge = t.signal & ~registered_signals.signal;
    output_tx.neg_edge = ~t.signal & registered_signals.signal;

    // send expected output to scoreboard
    pred_ap.write(output_tx);
  endfunction: write
endclass: predictor
