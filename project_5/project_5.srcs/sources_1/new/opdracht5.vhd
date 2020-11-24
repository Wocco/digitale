--Wout Van Uytsel
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Opteller voor 2 32bit floating point getallen
entity opdracht5 is
Port (CLK100MHZ: in std_logic
--we kunnen de standaard klok  gebruiken van het boardje
);
end opdracht5;

architecture Behavioral of opdracht5 is
--signalen 
signal numberA:std_logic_vector(31 downto 0);
signal numberB:std_logic_vector(31 downto 0);
signal enable:std_logic;
signal solution:std_logic_vector(31 downto 0);

signal signA:std_logic;
signal signB:std_logic;

signal exponentA:std_logic_vector(7 downto 0);
signal exponentB:std_logic_vector(7 downto 0);
signal mantissaA:std_logic_vector(27 downto 0);
signal mantissaB:std_logic_vector(27 downto 0);

signal exponentS:std_logic_vector(7 downto 0);
signal mantissaS:std_logic_vector(27 downto 0);
signal signS:std_logic;

begin
--er zijn een paar speciale gevallen bij de floating point hier moeten we zeker eerst voor checken
signA<=numberA(31);
signB<=numberB(31);

exponentA<=numberA(30 downto 23);
exponentB<=numberB(30 downto 23);

mantissaA<=numberA(22 downto 0);
mantissaB<=numberB(22 downto 0);


berekening: process(numberA,numberB,enable)
begin  
--eerst gaan we moeten checken of er speciale gevallen zijn. Dit is belangrijk want we kunnen ook Nan voorstellen alsook oneindig
if(enable='1')then 

    if((exponentA="11111111"  and mantissaA/="0000000000000000000000")or (exponentB="11111111" and mantissaB/="0000000000000000000000"))then
    --een van de twee is NaN
    --we geven ook NAN terug
        signS<='0';
        exponentS<="11111111";
        mantissaS<="1000000000000000000000";
        solution<=signS & exponentS & mantissas;
    elsif((exponentA="11111111"  and mantissaA="0000000000000000000000" and signA='0') and (exponentB="11111111"  and mantissaB="0000000000000000000000" and signB='0'))then
    --+oneindig + +oneindig
    solution<="0111111110000000000000000000000";--we geven ook +oneindig terug
    elsif((exponentA="11111111"  and mantissaA="0000000000000000000000" and signA='1') and (exponentB="11111111"  and mantissaB="0000000000000000000000" and signB='0'))then
    --Nu doen we _oneindig + oneindig gaat niet dus we geven Nan terug
    signS<='0';
    exponentS<="11111111";
    mantissaS<="1000000000000000000000";
    
    elsif((exponentA="11111111"  and mantissaA="0000000000000000000000" and signA='0') and (exponentB="11111111"  and mantissaB="0000000000000000000000" and signB='1'))then
    --Nu doen we _oneindig + oneindig gaat niet dus we geven Nan terug
    signS<='0';
    exponentS<="11111111";
    mantissaS<="1000000000000000000000";
    end if;
    
end if;

               
end process;

end Behavioral;
