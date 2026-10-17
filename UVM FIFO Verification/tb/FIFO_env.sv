package FIFO_env_pkg;
import FIFO_agent_pkg::*;
import FIFO_cov_pkg::*;
import FIFO_sb_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_env extends uvm_env;
    `uvm_component_utils(FIFO_env)
    FIFO_agent agt;
    FIFO_cov cov;
    FIFO_sb sb;

    function new (string name = "FIFO_env",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = FIFO_agent::type_id::create("agt",this);
        cov = FIFO_cov::type_id::create("cov",this);
        sb = FIFO_sb::type_id::create("sb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction
endclass
endpackage