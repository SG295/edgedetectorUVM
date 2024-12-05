`ifndef TRANSACTION_SVH
`define TRANSACTION_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class transaction #(parameter NUM_BITS = 1) extends uvm_sequence_item;
  rand bit [NUM_BITS - 1:0] signal;
  bit [NUM_BITS - 1:0] pos_edge, neg_edge;

  `uvm_object_utils_begin(transaction)
    `uvm_field_int(signal, UVM_NOCOMPARE)
    `uvm_field_int(pos_edge, UVM_DEFAULT)
    `uvm_field_int(neg_edge, UVM_DEFAULT)
  `uvm_object_utils_end

  // add constrains for randomization

  function new(string name = "transaction");
    super.new(name);
  endfunction: new

  // if two transactions are the same, return 1
  function int input_equal(transaction tx);
    int result;
    if((signal == tx.signal)) begin
      result = 1;
      return result;
    end
    result = 0;
    return result;
  endfunction
endclass

`endif
