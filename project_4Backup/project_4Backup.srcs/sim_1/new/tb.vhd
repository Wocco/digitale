library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.examplepackage.all;
entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
component top
    port(
    CLK100MHZ: in std_logic
    );
    end component;
    signal CLK100MHZ: std_logic := '0';
begin
disp:top
port map(CLK100MHZ=>CLK100MHZ);
psim:process
    begin
    wait for 5ns;
    CLK100MHZ<=not CLK100MHZ;
    
    end process;


end Behavioral;
