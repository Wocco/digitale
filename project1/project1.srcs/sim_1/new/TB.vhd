library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity TB is


end TB;

architecture Behavioral of TB is
component controller
    port(
    CLK100MHZ: in std_logic
    );
    end component;
    signal CLK100MHZ: std_logic := '0';
begin
disp:controller
port map(CLK100MHZ=>CLK100MHZ);
psim:process
begin
CLK100MHZ<=not CLK100MHZ;
    wait for 5ns;
end process;


end Behavioral;
