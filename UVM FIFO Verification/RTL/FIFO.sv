////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.dut v_if);

localparam max_fifo_addr = $clog2(v_if.FIFO_DEPTH);

reg [v_if.FIFO_WIDTH-1:0] mem [v_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge v_if.clk or negedge v_if.rst_n) begin
	if (!v_if.rst_n) begin
		wr_ptr <= 0;
		v_if.wr_ack <= 0; //bug 4
		v_if.overflow <= 0;
	end
	else if (v_if.wr_en && count < v_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= v_if.data_in;
		v_if.wr_ack <= 1;
		v_if.overflow <= 0; //bug 5
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		v_if.wr_ack <= 0; 
		if (v_if.full & v_if.wr_en)
			v_if.overflow <= 1;
		else
			v_if.overflow <= 0;
	end
end

always @(posedge v_if.clk or negedge v_if.rst_n) begin
	if (!v_if.rst_n) begin
		rd_ptr <= 0;
		v_if.data_out <= 0; //bug 6
	end
	else if (v_if.rd_en && count != 0) begin
		v_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge v_if.clk or negedge v_if.rst_n) begin
	if (!v_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({v_if.wr_en, v_if.rd_en} == 2'b10) && !v_if.full) 
			count <= count + 1;
		else if ( ({v_if.wr_en, v_if.rd_en} == 2'b01) && !v_if.empty)
			count <= count - 1;
		else if({v_if.wr_en , v_if.rd_en} == 2'b11)begin //bug 3
			if(v_if.empty) count <= count +1;
			else if(v_if.full) count <= count -1;
		end
	end
end

always @(posedge v_if.clk or negedge v_if.rst_n) begin //bug 2 fix
    if (!v_if.rst_n)
        v_if.underflow <= 0;
    else if (v_if.rd_en && v_if.empty)
        v_if.underflow <= 1;
    else
        v_if.underflow <= 0;
end

assign v_if.full = (count == v_if.FIFO_DEPTH)? 1 : 0;
assign v_if.empty = (count == 0)? 1 : 0;
// assign v_if.underflow = (v_if.empty && v_if.rd_en)? 1 : 0; bug 2
assign v_if.almostfull = (count == v_if.FIFO_DEPTH-1)? 1 : 0; //bug 1
assign v_if.almostempty = (count == 1)? 1 : 0;

endmodule