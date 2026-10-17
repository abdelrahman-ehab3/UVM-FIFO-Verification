import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module FIFO_top();

bit clk;

initial begin
    clk = 0;
    forever begin
        #2 clk = ~clk;
    end
end

FIFO_if v_if(clk);
FIFO DUT (v_if.dut);

bind FIFO FIFO_sva #(.ADDR_W(max_fifo_addr)) sva_inst (
    .v_if   (v_if),
    .wr_ptr (wr_ptr),
    .rd_ptr (rd_ptr),
    .count  (count)
);

initial begin
    uvm_config_db #(virtual FIFO_if)::set(null,"uvm_test_top","vif",v_if);
    run_test("FIFO_test");
end
endmodule