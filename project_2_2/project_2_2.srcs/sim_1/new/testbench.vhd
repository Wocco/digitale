library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity testbench is
--  Port ( );
end testbench;



architecture Behavioral of testbench is
component drawline
port (
x0: in std_logic_vector(9 downto 0);
y0: in std_logic_vector(8 downto 0);
x1: in std_logic_vector(9 downto 0);
y1: in std_logic_vector(8 downto 0);
start: in std_logic;
--klok signaal
clk: in STD_LOGIC;
--outputs zie opdracht voor tekening
currentx : out std_logic_vector(9 downto 0);
currenty : out std_logic_vector(8 downto 0);
plot : out STD_LOGIC);
end component;

signal x0,x1,currentx: STD_LOGIC_VECTOR (9 downto 0);
signal y0,y1,currenty: STD_LOGIC_VECTOR (8 downto 0);
signal Start, Plotting, CLK: STD_LOGIC:= '0';
begin
dut: DrawLine
port map (
            x0 => x0,
            y0 => y0,
            x1 => x1,
            y1 => y1,
            Start => Start, 
            currentx => currentx,
            currenty => currenty,
            plot => Plotting,
            
            CLK => CLK
            );
         process
          variable temp : integer;
           begin  
           wait for 10ns; 
 Start <= '1';
                   
                   X0 <= std_logic_vector(to_unsigned(1,10));
                   Y0 <= std_logic_vector(to_unsigned(18,9));
                   X1 <= std_logic_vector(to_unsigned(14,10));
                   Y1 <= std_logic_vector(to_unsigned(121,9));
                   
                   wait for 10 ns;
                   Start <='0';
                   wait for 10 ns;
                   end process;
                   
                   
                   p_Clock: process
                   begin 
                       CLK<= not CLK;
                       wait for 10ns; 
                   end process p_Clock;
end Behavioral;
