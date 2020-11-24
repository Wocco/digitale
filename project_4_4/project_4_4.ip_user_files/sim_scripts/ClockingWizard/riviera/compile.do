vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../ipstatic" \
"../../../../Opgave4.srcs/sources_1/ip/ClockingWizard/ClockingWizard_clk_wiz.v" \
"../../../../Opgave4.srcs/sources_1/ip/ClockingWizard/ClockingWizard.v" \


vlog -work xil_defaultlib \
"glbl.v"

