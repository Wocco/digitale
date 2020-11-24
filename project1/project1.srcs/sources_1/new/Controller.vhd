library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--in de entity beschrijf je externe poorten (inputs en outputs) zodat je ze kan gebruiken in je design
entity Controller is
 Port (
    CLK100MHZ : in std_logic;
    VGA_R : out std_logic_vector(3 downto 0);
    VGA_G : out std_logic_vector(3 downto 0);
    VGA_B : out std_logic_vector(3 downto 0);
    VGA_HS : out std_logic;
    VGA_VS : out std_logic
    );
end Controller;


architecture Behavioral of Controller is
    --signals van de video memory etc
    signal clka:STD_LOGIC;
    signal wea:STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addra : STD_LOGIC_VECTOR(18 DOWNTO 0);
    signal dina :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal douta :STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal clkb :  STD_LOGIC;
    signal web :  STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addrb : STD_LOGIC_VECTOR(18 DOWNTO 0);
    signal dinb :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal doutb : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal tellerdata: STD_LOGIC_VECTOR(18 DOWNTO 0);
    -- Signals van het scherm
    
    signal pixelClock : std_logic;
    signal Write : std_logic;
    signal x : integer ;
    signal y : integer;
    
    -- Components 
    --poorten clocking wizard voor de klok klok van het vga scherm te genereren 
    component ClockingWizard
    Port(
      pixelClock : out std_logic;
      CLK100MHZ  : in  std_logic);
    end component;
    
    component VPulse
    Port (
        pixelClock: in std_logic;
        
        HSync : out std_logic;
        VSync : out std_logic;
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
        
     );
     end component;
    --videomemory 
    component VideoMemory
       PORT (
         clka : IN STD_LOGIC;
         wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
         dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         clkb : IN STD_LOGIC;
         web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
         dinb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
       );
     END COMPONENT;
    
begin
    clk : ClockingWizard
    --poorten linken aan in / uigangen 
    Port map(
        pixelClock => pixelClock,
        CLK100MHZ => CLK100MHZ);
     
     VSync : VPulse
     Port map(
        pixelClock => pixelClock,
        HSync => VGA_HS,
        VSync => VGA_VS,
        xPos => x,
        yPos => y,
        Write => Write);
        --de port map van de videomemory 
    VideoMem : VideoMemory
    PORT MAP (
            clka => '0',
            wea => "0",
            addra => "0000000000000000000",
            dina => "000",
            douta => open,
            clkb => pixelclock,
            web => "0",
            addrb => tellerdata,
            dinb => "000",
            doutb => doutb
          );
          --het schrijven naar je scherm 
          
    pUpdateDisplay : process(x,y,Write)
    --schrijf hier de code voor het scherm aan te sturen
    begin
    
   if (write='1') then
           if (doutb(2 downto 2)="1")   
           then
           VGA_R <="1111";
           else
           VGA_R <="0000";
           end if;
           
           if (doutb(1 downto 1)="1")   
                then
                VGA_G <="1111";
                else
                VGA_G <="0000";
           end if;
           
           if (doutb(0 downto 0 )="1")   
                 then
                 VGA_B <="1111";
                 else
                 VGA_B <="0000";
            end if;
          end if;     
    
     if(Write = '0')
                       then
                    VGA_R <= "0000";
                      VGA_G <= "0000";
                      VGA_B <= "0000";
                      end if;
    end process;
    p_clock:process(pixelclock)is
    begin
     if(Write = '1')
       then
              if(rising_edge(pixelClock))
              then
              
                   tellerdata <= std_logic_vector(to_unsigned(to_integer(unsigned(tellerdata))+1,19));
                     if tellerdata >="1001011000000000000" then
                     tellerdata<="0000000000000000000";
                                                    end if;
                  
              end if;
              end if;
    end process;
end Behavioral;
