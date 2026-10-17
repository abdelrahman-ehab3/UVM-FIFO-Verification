package FIFO_seq_pkg;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_reset_seq extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_reset_seq)
    FIFO_seq_item seq_item;

    function new (string name = "FIFO_reset_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.data_in = 0;
        seq_item.rst_n = 0;
        seq_item.wr_en = 0;
        seq_item.rd_en = 0;
        finish_item(seq_item);
    endtask
endclass

class FIFO_write_only_seq extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_write_only_seq)
    FIFO_seq_item seq_item;

    function new (string name = "FIFO_write_only_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        repeat(10)begin
        start_item(seq_item);
        assert(seq_item.randomize() with {wr_en == 1; rd_en == 0; rst_n == 1;});
        finish_item(seq_item);
        end
    endtask
endclass

class FIFO_read_only_seq extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_read_only_seq)
    FIFO_seq_item seq_item;

    function new (string name = "FIFO_read_only_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        repeat(10)begin
        start_item(seq_item);
        assert(seq_item.randomize() with {wr_en == 0; rd_en == 1; rst_n == 1;});
        finish_item(seq_item);
        end
    endtask
endclass

class FIFO_read_write_seq extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_read_write_seq)
    FIFO_seq_item seq_item;

    function new (string name = "FIFO_read_write_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        repeat(100)begin
        start_item(seq_item);
        assert(seq_item.randomize() with {wr_en == 1; rd_en == 1; rst_n == 1;});
        finish_item(seq_item);
        end
    endtask
endclass

class FIFO_fully_randomized_seq extends uvm_sequence #(FIFO_seq_item);
    `uvm_object_utils(FIFO_fully_randomized_seq)
    FIFO_seq_item seq_item;

    function new (string name = "FIFO_fully_randomized_seq");
        super.new(name);
    endfunction

    task body;
        seq_item = FIFO_seq_item::type_id::create("seq_item");
        repeat(10000)begin
        start_item(seq_item);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
    endtask
endclass
endpackage