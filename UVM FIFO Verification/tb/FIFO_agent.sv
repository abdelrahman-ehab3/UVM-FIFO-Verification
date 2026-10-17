package FIFO_agent_pkg;
import FIFO_driver_pkg::*;
import FIFO_mon_pkg::*;
import FIFO_cfg_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_sequencer_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_agent extends uvm_agent;
    `uvm_component_utils(FIFO_agent)
    FIFO_cfg cfg;
    FIFO_driver drv;
    FIFO_mon mon;
    FIFO_sequencer sqr;
    uvm_analysis_port #(FIFO_seq_item) agt_ap;

    function new (string name = "FIFO_agent",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(FIFO_cfg)::get(this,"","CFG",cfg))begin
            `uvm_fatal("build phase","Unable to get config obj")
        end

        drv = FIFO_driver::type_id::create("drv",this);
        mon = FIFO_mon::type_id::create("mon",this);
        sqr = FIFO_sequencer::type_id::create("sqr",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.vif = cfg.vif;
        mon.vif = cfg.vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_ap.connect(agt_ap);
    endfunction
endclass
endpackage