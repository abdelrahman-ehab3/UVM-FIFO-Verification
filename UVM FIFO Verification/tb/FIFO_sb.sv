package FIFO_sb_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_sb extends uvm_scoreboard;
    `uvm_component_utils(FIFO_sb)
    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
    FIFO_seq_item sb_seq_item;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] ref_queue[$];

    int error_counter = 0;
    int correct_counter = 0;

    function new (string name = "FIFO_sb",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task ref_model (FIFO_seq_item s_item);
        bit do_read;
        bit do_write;

        if (!s_item.rst_n) begin
            ref_queue.delete();
            return;
        end

        do_read  = s_item.rd_en && (ref_queue.size() != 0);
        do_write = s_item.wr_en && (ref_queue.size() <  FIFO_DEPTH);

        if (do_read) begin
            data_out_ref = ref_queue.pop_front();
            if (s_item.data_out === data_out_ref) begin
                correct_counter++;
            end
            else begin
                `uvm_error("run_phase",$sformatf("data_out mismatch: DUT=%s, REF=%0d",s_item.convert2string(), data_out_ref))
                error_counter++;
            end
        end

        if (do_write)
            ref_queue.push_back(s_item.data_in);
    endtask

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(sb_seq_item);
            ref_model(sb_seq_item);
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report phase",$sformatf("Total successful transactions = %0d",correct_counter),UVM_MEDIUM)
        `uvm_info("report phase",$sformatf("Total failed transactions = %0d",error_counter),UVM_MEDIUM)
    endfunction
endclass
endpackage