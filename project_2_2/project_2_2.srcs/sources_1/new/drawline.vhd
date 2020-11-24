library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

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
    signal p: integer:=0;
    signal dx,dy: integer;
    --verschillende staten van de finite state machine
    type t_State is (beginnen,change_e2,Berekenerror,Drawing,Done);
    signal State: t_State:=Done;
    --sx en sy zijn de currentx en current y maar als integer en signaal
    signal sx: integer;
    signal sy: integer;
    signal plusx,plusy: integer range -1 to 1;
    --de error berekenen
    signal err,e2: integer;
    --of het programma bezig is
    signal busy: std_logic:='0';

begin
--altijd omzetten (concurrent)

currentx<= std_logic_vector(to_unsigned(sx,10));
currenty<= std_logic_vector(to_unsigned(sy,9));
plot <=busy;

pClock : process(Clk)
   begin 
   if(rising_edge(clk)) then 
 case State is 
          when beginnen => 
                 sx <= to_integer(unsigned(x0)); 
                 sy <= to_integer(unsigned(y0));            
                 --om te beginnen zetten we in sx,sy de begincoordinaten omdat we ook hier starten.
                 --Daarna gaan we kijken of de lijn naar links of rechts gaat.
                 --x0<x1 dan gaat de lijn naar rechts. Omdat we geen absolute waarden gebruiken berekenen we nu dx door x1-X0 te doen.
                 --dit betekent ook dat we +1 moeten doen om dichter bij ons eindpunt te raken vanuit x0
                 if x0<x1 then 
                      plusx <= 1; 
                      dx <= to_integer(unsigned(x1))- to_integer(unsigned(x0));
                 else 
                 --Als dit niet zo is gaat de lijn naar links. Dit betekent dat we -1 moeten doen vertrekkende van x0 anders gaan we de verkeerde richting uit.
                 --Om dx te berekenen doen we nu x0-x1. Want X0 is groter als x1
                      plusx <= -1;  
                      dx <= to_integer(unsigned(x0))- to_integer(unsigned(x1));
                 end if;
                 --als y0 kleiner is als y1 dan gaat de lijn naar onder.Dit betekent dat we bij y0 moeten optellen om dichter bij ons eindpunt te raken.
                 --we berekenen ook weer dy idem aan x maar dan met y
                 if y0<y1 then 
                      plusy <= 1;
                      dy <= to_integer(unsigned(y1))- to_integer(unsigned(y0));
                 else 
                      --de lijn gaat naar boven. Dus gaan we -1 moeten doen met y0 om dichter bij het eindpunt te raken.
                      plusy <= -1;  
                      dy <= to_integer(unsigned(y0))- to_integer(unsigned(y1));
                 end if;
                 --we hebben dx en dy en of we +1 of -1 moeten doen bij x,y nu kunnen we verder gaan naar de volgende stap.
                 State <= Berekenerror;
          --er is een apparte state voor het berekenen van een error omdat pas na een klokflank de waarde wordt toegekened
          --en we hebben de berekening van het verschil van dx en dy nodig voor verder te gaan
          when Berekenerror =>
                 err <= dx - dy;
                 
                 --we gaan naar de volgende state
                 State <= change_e2; 
               
          when change_e2 =>   
          --we berekenen de error 2       
                 e2<=err*2;    
                 --nu gaan we tekenen
                 busy <= '1'; --plot='1'                 
                 State <= Drawing;
          when Drawing =>
                --als deze if waar is zijn we aangekomen in het eindpunt en hoeven we dus niet verder te gaan
                 if sx=to_integer(unsigned(x1)) and sy=to_integer(unsigned(y1)) then 
                     --alles is klaar dus plot mag terug nul worden 
                     busy <='0';
                     State <= Done;
                 else 
                    --we zijn nog niet aangekomen in het eindpunt
                     --als de error2 groter is als -dy (dy is altijd een positief getal) error2 is enkel negatief als dx kleiner is als dy dus als de rico van x kleiner is als die van y
                     --en als error2 kleiner is als dx dus als (dx-dy)*2 kleiner is als de rico van x
                     if e2 > -dy and e2 < dx then 
                     --we nemen een stap met x en y
                           err <= err - dy + dx;  
                           sx <= sx + plusx; 
                           sy <= sy + plusy;
                     elsif e2 > -dy then 
                     --als de (dx-dy)*2 groter is als de -rico van y
                     -- we nemen een stap op de x richting
                          err <= err - dy;
                          sx <= sx + plusx; 
                     elsif e2 < dx then 
                     -- we nemen een stap in de y richting
                     -- als (dx-dy)*2 kleiner is als dx betekent dat dat dy overweegt tegenover dx en er dus een stap moet genomen worden op de y richting
                          err <= err + dx;
                          sy <= sy + plusy;                   
                     end if;
                     --we gaan terug error 2 berekenen want err is aangepast
                     State <= change_e2;
                 end if; 
          when Done =>    
              if Start='1' then
                  State <= beginnen;
              end if;                            
      end case;
      end if;
      
      end process;

end Behavioral;