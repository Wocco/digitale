--Wout Van Uytsel
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package examplepackage is
--hier gaan we de componenten definieren

--dit is de lfsr pseudorandom generator 
component lfsr is port(
--q is de output van de lfsr

clock : in std_logic
);
end component lfsr;


--dit is de drawline/ bresenham algoritme
component drawline is port(
--inputs
--zie opdracht voor tekening
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
end component drawline;

-- dit is de component voor de vga aansturing
component vga is port(
    CLK100MHZ : in std_logic;
    VGA_R : out std_logic_vector(3 downto 0);
    VGA_G : out std_logic_vector(3 downto 0);
    VGA_B : out std_logic_vector(3 downto 0);
    --horizontal sync
    VGA_HS : out std_logic;
    --vertical sync
    VGA_VS : out std_logic
    );
end component vga;

component VPulse is Port (
        pixelClock: in std_logic;
        
        HSync : out std_logic;
        VSync : out std_logic;
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
     );
     end component Vpulse;

component VideoMemory is port(
         clka : IN STD_LOGIC;
         wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
         dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         clkb : IN STD_LOGIC;
         web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
         dinb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
end component VideoMemory;

component ClockingWizard is port(
      pixelClock : out std_logic;
      CLK100MHZ  : in  std_logic);
    end component ClockingWizard;
    
    component HPulse is
            Port(
            Clock_in  : in  std_logic;
            Can_write : out std_logic;
            Xpos      : out integer; --range 0 to g_visible - 1; Kijk of dit niet de reden was
            Sync      : out std_logic;
            HCounter_out  : out integer
            );
        end component Hpulse;
        
        
   component TriangleFifo is
   Port(
   wr_en: in std_logic;
   din: in std_logic_vector(58 downto 0);
   dout: out std_logic_vector(58 downto 0);
   rd_en: in std_logic;
   full: out std_logic;
   empty: out std_logic;
   clk: in std_logic;
   srst: in std_logic
   );
   end component TriangleFifo;
end package examplepackage;