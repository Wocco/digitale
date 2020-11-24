--Wout Van Uytsel
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr is
generic(
numofbits : integer :=15
);

Port (
q :out std_logic_vector(15 downto 0);--De reeks is 16 bits lang
--als je een variable seed had zou je die hier ook nog kunnen inlezen maar hier is deze vast
clock : in std_logic);
end lfsr;

architecture Behavioral of lfsr is

signal qs: std_logic_vector(0 to numofbits):="1000000000000000";--de hexadecimale waarde omgevormd naar binair

begin
lfsr: process(clock) begin
    if rising_edge(clock) then
    --opschuiven van de bits 
    qs(15) <=qs(14);
    qs(14) <= qs(13);
    qs(13) <= qs(12);
    qs(12) <= qs(11) ;
    qs(11) <= qs(10) ;
    qs(10) <= qs(9) ;
    qs(9) <= qs(8);
    qs(8) <= qs(7); 
    qs(7) <= qs(6);
    qs(6) <= qs(5);
    qs(5) <= qs(4);
    qs(4) <= qs(3);
    qs(3) <= qs(2);
    qs(2) <= qs(1);
    qs(1) <= qs(0);
    qs(0) <= ((qs(15) xor qs(13)) xor qs(12)) xor qs(10);
    --pas na de klokflank zullen al deze waarde worden doorgegeven
    end if; 
end process;
--we zullen altijd qs in q zetten.
q <=qs;
end Behavioral;
