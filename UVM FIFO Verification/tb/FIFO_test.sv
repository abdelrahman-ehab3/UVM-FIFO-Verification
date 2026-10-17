package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_cfg_pkg::*;
import FIFO_seq_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;
    `uvm_component_utils(FIFO_test)
    virtual FIFO_if vif;
    FIFO_env env;
    FIFO_cfg cfg;
    FIFO_reset_seq reset_seq;
    FIFO_write_only_seq write_seq;
    FIFO_read_only_seq read_seq;
    FIFO_read_write_seq mixed_seq;
    FIFO_fully_randomized_seq rand_seq;

    function new (string name = "FIFO_test" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = FIFO_env::type_id::create("env",this);
        cfg = FIFO_cfg::type_id::create("cfg",this);
        reset_seq = FIFO_reset_seq::type_id::create("reset_seq",this);
        write_seq = FIFO_write_only_seq::type_id::create("write_seq",this);
        read_seq = FIFO_read_only_seq::type_id::create("read_seq",this);
        mixed_seq = FIFO_read_write_seq::type_id::create("mixed_seq",this);
        rand_seq = FIFO_fully_randomized_seq::type_id::create("rand_seq",this);
        if(!uvm_config_db #(virtual FIFO_if)::get(this,"","vif",cfg.vif))
            `uvm_fatal("build phase","Test unable to get virtual if")
        
        uvm_config_db #(FIFO_cfg)::set(this,"*","CFG",cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run phase","reset asserted",UVM_LOW)
        reset_seq.start(env.agt.sqr);
        `uvm_info("run phase","reset deasserted",UVM_LOW)

        `uvm_info("run phase","wr_en = 1 & rd_en = 0",UVM_LOW)
        write_seq.start(env.agt.sqr);
        `uvm_info("run phase","sequence finished",UVM_LOW)

        `uvm_info("run phase","wr_en = 0 & rd_en = 1",UVM_LOW)
        read_seq.start(env.agt.sqr);
        `uvm_info("run phase","sequence finished",UVM_LOW)

        `uvm_info("run phase","wr_en = 1 & rd_en = 1",UVM_LOW)
        mixed_seq.start(env.agt.sqr);
        `uvm_info("run phase","sequence finished",UVM_LOW)

        `uvm_info("run phase","Fully randomized sequence begin",UVM_LOW)
        rand_seq.start(env.agt.sqr);
        `uvm_info("run phase","sequence finished",UVM_LOW)

        phase.drop_objection(this);
    endtask
endclass
endpackage