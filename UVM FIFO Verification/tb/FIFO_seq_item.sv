package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_seq_item extends uvm_sequence_item;
    `uvm_object_utils(FIFO_seq_item)

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    int RD_EN_ON_DIST = 30;
    int WR_EN_ON_DIST = 70;

    rand logic [FIFO_WIDTH-1:0] data_in;
    rand logic rst_n, wr_en, rd_en;

    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    function new (string name = "FIFO_seq_item");
        super.new(name);
    endfunction

    constraint reset {
            rst_n dist {0:/3 , 1:/97};
        }

        constraint enables {
            wr_en dist {1:/WR_EN_ON_DIST , 0:/100-WR_EN_ON_DIST};
            rd_en dist {1:/RD_EN_ON_DIST , 0:/100-RD_EN_ON_DIST};
        }
    function string convert2string();
        return $sformatf("%s data in =%0d, rst_n = %0b, wr_en = %0b, rd_en = %0b, data out = %0d, full = %0b, empty = %0b, almost full = %0b, almost empty = %0b, over flow = %0b, under flow = %0b, wr_ack = %0b",
        super.convert2string(),data_in,rst_n,wr_en,rd_en,data_out,full,empty,almostfull,almostempty,overflow,underflow,wr_ack);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("data in =%0d, rst_n = %0b, wr_en = %0b, rd_en = %0b",
        data_in,rst_n,wr_en,rd_en,data_out,full,empty,almostfull,almostempty,overflow,underflow,wr_ack);
    endfunction
endclass
endpackage