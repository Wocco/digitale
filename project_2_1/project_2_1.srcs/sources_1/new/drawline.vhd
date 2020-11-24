library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

--in de entity beschrijf je externe poorten (inputs en outputs) zodat je ze kan gebruiken in je design deze moeten dezelfde naam hebben als in de .xdc file

entity drawline is
Port (
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
plot : out STD_LOGIC


 );
end drawline;

architecture Behavioral of drawline is
--signalen
    signal dx: integer;
    signal dy: integer;
    signal p: integer;
    signal x: integer;
    signal y: integer;
    signal busy: STD_LOGIC;
    signal done: STD_LOGIC;
    signal i: integer:=0;
    signal py: integer;
    signal px: integer;
    signal lo: integer;
    
begin
    
    pClock : process(Clk)
    begin
        --stijgend kloksingnaal
        if(rising_edge(Clk))
        then
            --berekeningen
            dx <= to_integer(unsigned(abs(x1-x0)));
            dy <= to_integer(unsigned(abs(y1-y0)));
            x <=to_integer(unsigned(x0));
            y <= to_integer(unsigned(y0));
            p <= 2*dy-dx;
            --
            
            if(start ='1' and busy='0' and done='0')
            then
                busy<='1';
                lo <='1'
                --als x0 groter is als x1 dan gaat de lijn naar rechts
                if (x0>x1)
                then
                    y <= to_integer(unsigned(y1));
                    x <= to_integer(unsigned(x1));
                    py <= to_integer(unsigned(y0));
                    px <= to_integer(unsigned(x0));
                    --als y0 - y1 positief is gaat de lijn naar beneden
                    if((to_integer(signed(y0-y1)))<0)
                    then
                        i<=-1;
                    else
                        i<=1;
                    end if;


                else
                    --de lijn gaat naar links
                    y<=to_integer(unsigned(y0));
                    x<=to_integer(unsigned(x0));
                    py <= to_integer(unsigned(y1));
                    px <= to_integer(unsigned(x1));
                    if((to_integer(signed(y1-y0)))<0)
                    then
                        i<=-1;
                    else
                        i<=1;
                    end if;
                end if;
            else
                lo<='0';
            end if;
        end if;--van de klok
    end process;

end Behavioral;
