import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.svh"

class test extends uvm_test;
  `uvm_component_utils(test)

  environment env;
  virtual edgedetector_if vif;
  edgedetector_sequence seq;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
    seq = edgedetector_sequence::type_id::create("seq");

    // send interface down
    if (!uvm_config_db#(virtual edgedetector_if)::get(this, "", "edgedetector_vif", vif)) begin
      `uvm_fatal("Test", "No virtual interface specified for this test instance")
    end

    uvm_config_db#(virtual edgedetector_if)::set(this, "env.agt*", "edgedetector_vif", vif);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this, "Starting sequence in main phase");
    $display("%t Starting sequence run_phase", $time);
    seq.start(env.agt.sqr);
    #100ns;
    phase.drop_objection(this, "Finished in main phase");
  endtask
endclass: test
