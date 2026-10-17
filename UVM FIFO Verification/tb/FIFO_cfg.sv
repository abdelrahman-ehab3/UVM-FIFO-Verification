package FIFO_cfg_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_cfg extends uvm_object;
    `uvm_object_utils(FIFO_cfg)

    virtual FIFO_if vif;

    function new (string name = "FIFO_cfg");
        super.new(name);
    endfunction
endclass
endpackage