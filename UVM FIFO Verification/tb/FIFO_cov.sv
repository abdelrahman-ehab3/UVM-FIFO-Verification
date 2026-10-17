package FIFO_cov_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_cov extends uvm_component;
    `uvm_component_utils(FIFO_cov)
    uvm_analysis_export #(FIFO_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
    FIFO_seq_item cov_seq_item;

    covergroup g1;
            write_enable : coverpoint cov_seq_item.wr_en {
                bins wr_en_bins[] = {[0:1]};
            }
            read_enable : coverpoint cov_seq_item.rd_en {
                bins rd_en_bins[] = {[0:1]};
            }
            wr_ack : coverpoint cov_seq_item.wr_ack {
                bins wr_ack_bins[] = {[0:1]};
            }
            overflow : coverpoint cov_seq_item.overflow {
                bins overflow_bins[] = {[0:1]};
            }
            full : coverpoint cov_seq_item.full {
                bins full_bins[] = {[0:1]};
            }
            empty : coverpoint cov_seq_item.empty {
                bins empty_bins[] = {[0:1]};
            }
            almostfull : coverpoint cov_seq_item.almostfull {
                bins almostfull_bins[] = {[0:1]};
            }
            almostempty : coverpoint cov_seq_item.almostempty {
                bins almostempty_bins[] = {[0:1]};
            }
            underflow : coverpoint cov_seq_item.underflow {
                bins underflow_bins[] = {[0:1]};
            }
            wr_ack_cc : cross write_enable , read_enable , wr_ack{
                bins wr_ack_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(wr_ack.wr_ack_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            overflow_cc : cross write_enable , read_enable , overflow{
                bins overflow_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(overflow.overflow_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            full_cc : cross write_enable , read_enable , full{
                bins full_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(full.full_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            empty_cc : cross write_enable , read_enable , empty{
                bins empty_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(empty.empty_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            almostfull_cc : cross write_enable , read_enable , almostfull{
                bins almostfull_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(almostfull.almostfull_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            almostempty_cc : cross write_enable , read_enable , almostempty{
                bins almostempty_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(almostempty.almostempty_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }
            underflow_cc : cross write_enable , read_enable , underflow{
                bins underflow_cc = binsof(write_enable.wr_en_bins) && binsof(read_enable.rd_en_bins) && binsof(underflow.underflow_bins);
                option.weight = 5;
                option.cross_auto_bin_max = 0;
            }

        endgroup

        function new (string name = "FIFO_cov",uvm_component parent = null);
            super.new(name,parent);
            g1 = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(cov_seq_item);
                g1.sample();
            end
        endtask
endclass
endpackage