vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../clockingwiz/ClockingWizard_clk_wiz.v" \
"../../../../clockingwiz/ClockingWizard.v" \


vlog -work xil_defaultlib \
"glbl.v"

