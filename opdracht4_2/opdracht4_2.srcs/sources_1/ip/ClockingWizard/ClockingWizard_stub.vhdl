-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Tue Nov  5 15:20:49 2019
-- Host        : DESKTOP-3EC4Q02 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top ClockingWizard -prefix
--               ClockingWizard_ ClockingWizard_stub.vhdl
-- Design      : ClockingWizard
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockingWizard is
  Port ( 
    pixelClock : out STD_LOGIC;
    Clk100MHz : in STD_LOGIC
  );

end ClockingWizard;

architecture stub of ClockingWizard is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pixelClock,Clk100MHz";
begin
end;
