module FIFO_sva #(parameter ADDR_W = 3)
(
    FIFO_if.dut v_if,
    input [ADDR_W-1:0] wr_ptr,
    input [ADDR_W-1:0] rd_ptr,
    input [ADDR_W:0] count
);
//a.Reset Behaviour
	property Reset_Behaviour;
		@(posedge v_if.clk)
		!v_if.rst_n |-> (wr_ptr == 0 && rd_ptr == 0 && count == 0);
	endproperty
	Reset_Behaviour_p : assert property (Reset_Behaviour);
	Reset_Behaviour_c : cover property (Reset_Behaviour);

	//b.Write Acknowledge
	property Write_Acknowledge;
		@(posedge v_if.clk) disable iff(!v_if.rst_n)
		(v_if.wr_en && !v_if.full) |=> v_if.wr_ack;
	endproperty
	Write_Acknowledge_p : assert property (Write_Acknowledge);
	Write_Acknowledge_c : cover property (Write_Acknowledge);

	//c.Overflow Detection
	property Overflow_Detection;
		@(posedge v_if.clk) disable iff(!v_if.rst_n)
		(v_if.wr_en && v_if.full) |=> v_if.overflow;
	endproperty
	Overflow_Detection_p : assert property (Overflow_Detection);
	Overflow_Detection_c : cover property (Overflow_Detection);

	//d.Underflow Detection
	property Underflow_Detection;
		@(posedge v_if.clk) disable iff(!v_if.rst_n)
		(v_if.rd_en && v_if.empty) |=> v_if.underflow;
	endproperty
	Underflow_Detection_p : assert property (Underflow_Detection);
	Underflow_Detection_c : cover property (Underflow_Detection);

	//e.Empty Flag Assertion
	property Empty_Flag_Assertion;
		@(posedge v_if.clk)
		(count == 0) |-> v_if.empty;
	endproperty
	Empty_Flag_Assertion_p : assert property (Empty_Flag_Assertion);
	Empty_Flag_Assertion_c : cover property (Empty_Flag_Assertion);

	//f.Full Flag Assertion
	property Full_Flag_Assertion;
		@(posedge v_if.clk)
		(count == v_if.FIFO_DEPTH) |-> v_if.full;
	endproperty
	Full_Flag_Assertion_p : assert property (Full_Flag_Assertion);
	Full_Flag_Assertion_c : cover property (Full_Flag_Assertion);

	//g.Almost Full Condition
	property Almost_Full_Condition;
		@(posedge v_if.clk)
		(count == v_if.FIFO_DEPTH-1) |-> v_if.almostfull;
	endproperty
	Almost_Full_Condition_p : assert property (Almost_Full_Condition);
	Almost_Full_Condition_c : cover property (Almost_Full_Condition);

	//h.Almost Empty Condition
	property Almost_Empty_Condition;
		@(posedge v_if.clk)
		(count == 1) |-> v_if.almostempty;
	endproperty
	Almost_Empty_Condition_p : assert property (Almost_Empty_Condition);
	Almost_Empty_Condition_c : cover property (Almost_Empty_Condition);

	//i.Pointer Wraparound
	property Pointer_Wraparound_wr;
		@(posedge v_if.clk) disable iff(!v_if.rst_n)
		(wr_ptr == v_if.FIFO_DEPTH-1 && v_if.wr_en && !v_if.full) |=> (wr_ptr == 0);
	endproperty
	Pointer_Wraparound_wr_p : assert property (Pointer_Wraparound_wr);
	Pointer_Wraparound_wr_c : cover property (Pointer_Wraparound_wr);

	property Pointer_Wraparound_rd;
		@(posedge v_if.clk) disable iff(!v_if.rst_n)
		(rd_ptr == v_if.FIFO_DEPTH-1 && v_if.rd_en && !v_if.empty) |=> (rd_ptr == 0);
	endproperty
	Pointer_Wraparound_rd_p : assert property (Pointer_Wraparound_rd);
	Pointer_Wraparound_rd_c : cover property (Pointer_Wraparound_rd);

	//j.Pointer threshold
	property Pointer_threshold;
		@(posedge v_if.clk)
		(rd_ptr < v_if.FIFO_DEPTH && wr_ptr < v_if.FIFO_DEPTH && count <= v_if.FIFO_DEPTH);
	endproperty
	Pointer_threshold_p : assert property (Pointer_threshold);
	Pointer_threshold_c : cover property (Pointer_threshold);
endmodule