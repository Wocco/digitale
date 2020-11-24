onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib TriangleFifo_opt

do {wave.do}

view wave
view structure
view signals

do {TriangleFifo.udo}

run -all

quit -force
