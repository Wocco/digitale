// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Tue Sep 24 14:59:55 2019
// Host        : DESKTOP-3EC4Q02 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/Wout/Documents/School/3 digitale
//               Elektronica/project1/mem/VideoMemory_stub.v}
// Design      : VideoMemory
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module VideoMemory(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[18:0],dina[2:0],douta[2:0],clkb,web[0:0],addrb[18:0],dinb[2:0],doutb[2:0]" */;
  input clka;
  input [0:0]wea;
  input [18:0]addra;
  input [2:0]dina;
  output [2:0]douta;
  input clkb;
  input [0:0]web;
  input [18:0]addrb;
  input [2:0]dinb;
  output [2:0]doutb;
endmodule
