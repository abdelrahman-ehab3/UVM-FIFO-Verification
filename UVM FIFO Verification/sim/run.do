vlib work
vlog -f src_files.list +cover=bst -covercells
vsim -voptargs=+acc FIFO_top -cover -classdebug -uvmcontrol=all -assertdebug
add wave /FIFO_top/v_if/*
coverage save FIFO_top.ucdb -onexit
run -all
coverage report -assertion -output assertion_report.txt
coverage report -cvg -details -output functional_coverage_report.txt
#quit -sim
#vcover report FIFO_top.ucdb -details -annotate -all -du=FIFO -output coverage_report.txt