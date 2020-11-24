// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Tue Nov  5 15:20:49 2019
// Host        : DESKTOP-3EC4Q02 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top ClockingWizard -prefix
//               ClockingWizard_ ClockingWizard_stub.v
// Design      : ClockingWizard
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ClockingWizard(pixelClock, Clk100MHz)
/* synthesis syn_black_box black_box_pad_pin="pixelClock,Clk100MHz" */;
  output pixelClock;
  input Clk100MHz;
endmodule