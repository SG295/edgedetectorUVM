import uvm_pkg::*;
`include "uvm_macros.svh"
`include "edgedetector_if.svh"

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual edgedetector_if vif;

  uvm_analysis_port#(transaction) edgedetector_ap;
  uvm_analysis_port#(transaction) result_ap;
  transaction prev_tx; // check if new transaction has been sent

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    edgedetector_ap = new("edgedetector_ap", this);
    result_ap = new("result_ap", this);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual edgedetector_if)::get(this, "", "edgedetector_vif", vif)) begin
      `uvm_fatal("Monitor", "No virtual interface specified for this monitor instance")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    prev_tx = transaction#(4)::type_id::create("prev_tx");
    forever begin
      transaction tx;
      @(posedge vif.clk);
      tx = transaction#(4)::type_id::create("tx");
      tx.signal = vif.signal;

      if (!tx.input_equal(prev_tx)) begin // if new transaction has been sent
        edgedetector_ap.write(tx);
        // get outputs from DUT and send to scoreboard/comparator
	@(posedge vif.clk)
        tx.result_pos_edge = vif.pos_edge;
        tx.result_neg_edge = vif.neg_edge;
        result_ap.write(tx);
        prev_tx.copy(tx);
      end
    end
  endtask: run_phase
endclass: monitor
