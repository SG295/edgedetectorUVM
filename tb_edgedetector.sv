import uvm_pkg::*;
`include "edgedetector.sv"
`include "edgedetector_if.svh"
`include "test.svh"

module tb_edgedetector();
  logic clk;

  // generate clock
  initial begin
    clk = 0;
    forever #10 clk = !clk;
  end

  edgedetector_if edge_if(clk);

  edgedetector edgedet(edge_if.edgedet);
  initial begin
    uvm_config_db#(virtual edgedetector_if)::set(null, "", "edgedetector_vif", edge_if);
    run_test("test");
  end
endmodule
