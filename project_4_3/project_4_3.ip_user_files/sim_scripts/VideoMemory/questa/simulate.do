onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib VideoMemory_opt

do {wave.do}

view wave
view structure
view signals

do {VideoMemory.udo}

run -all

quit -force
