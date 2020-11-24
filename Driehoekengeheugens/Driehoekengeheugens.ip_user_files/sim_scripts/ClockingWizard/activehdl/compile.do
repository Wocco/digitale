vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../Opgave4.srcs/sources_1/ip/ClockingWizard/ClockingWizard_clk_wiz.v" \
"../../../../Opgave4.srcs/sources_1/ip/ClockingWizard/ClockingWizard.v" \


vlog -work xil_defaultlib \
"glbl.v"

