--Wout Van Uytsel
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.examplepackage.all;
entity top is
Port (    
--top levels pooren
--vga scherm sturing
CLK100MHZ : in std_logic;
VGA_R : out std_logic_vector(3 downto 0);
VGA_G : out std_logic_vector(3 downto 0);
VGA_B : out std_logic_vector(3 downto 0);
--horizontal sync
VGA_HS : out std_logic;
--vertical sync
VGA_VS : out std_logic

);

end top;

architecture Behavioral of top is  
    --signalen van de video memory etc 1
    type Geheugen1_State is(start,lijnophalen,lijnophalen2,varinlezen,beginnen,change_e2,Berekenerror,Drawing,Done);
    signal g1_State: Geheugen1_State:=start;
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
    -- Signalen van het 2de geheugen
    type Geheugen2_State is(start,bresen);
    signal g2_State: Geheugen1_State:=start;
    signal wea2:STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addra2 : STD_LOGIC_VECTOR(18 DOWNTO 0);
    signal dina2 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal douta2 :STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal clkb2 :  STD_LOGIC;
    signal web2 :  STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal addrb2 : STD_LOGIC_VECTOR(18 DOWNTO 0);
    signal dinb2 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal doutb2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal tellerdata2: STD_LOGIC_VECTOR(18 DOWNTO 0);
    
    --signalen van het vga scherm
    signal pixelClock : std_logic; -- de 25Mhz klok die het scherm nodig heeft
    signal Write : std_logic;--of we kunnen schrijven
    signal x : integer ;--x-coordinaat van dit moment
    signal y : integer;--y coordinaat van dit moment
    signal tel : integer;
    
    --signaal voor lfsr
    signal qs: std_logic_vector(56 downto 0):="000000000100000000000000010000001100000001000000000000000";--de hexadecimale waarde omgevormd naar binair

     --signalen fifo
    signal wr_en: std_logic:='0';
    signal din:  std_logic_vector(58 downto 0);
    signal dout: std_logic_vector(58 downto 0);
    signal rd_en: std_logic:='0';
    signal full: std_logic;
    signal empty: std_logic;
    type B_State is(start,wachten);
    signal Bstate: B_State:=start;
    type A_State is (start,twee);
    signal State: A_State:=start;
    signal telleraantaldriehoeken:integer:=0;
    signal newframe: std_logic_vector(0 downto 0):="0";
    signal newframetel: integer:=0;
    signal aantaldriehoeken: integer:=5;
    signal lijnperlijn: std_logic:='0';
 
 --signalen die nodig zijn voor bresenham

    signal klaarvoordata:std_logic:='0';
    signal recentstedata: std_logic_vector(58 downto 0):="00000000000100000000000000010000001100000001000000000000000"; 
    signal schermwit: std_logic:='0';
    signal startbres:std_logic:='0';
    signal tellerdriehoek: integer:=0;
    signal p: integer:=0;
    signal dx,dy: integer;
    --verschillende staten van de finite state machine
    
    --sx en sy zijn de currentx en current y maar als integer en signaal
    signal sx: integer;
    signal sy: integer;
    signal x0,x1: std_logic_vector(9 downto 0);
    signal y0,y1: std_logic_vector(8 downto 0);
    signal plusx,plusy: integer range -1 to 1;
    --de error berekenen
    signal err,e2: integer;
    --of het programma bezig is
    signal busy: std_logic:='0';
   
 
 
begin


clk : ClockingWizard
--poorten linken aan in / uigangen dit zijn de poorten voor de pixelclock
Port map(
    pixelClock => pixelClock,
    CLK100MHZ => CLK100MHZ);
    
lfsr1 :lfsr
port map(
clock => CLK100MHZ
);

VSync : VPulse
         Port map(
            pixelclock => pixelclock,
            HSync => VGA_HS,
            VSync => VGA_VS,
            xPos => x,
            yPos => y,
            Write => Write);
            
            

   VideoMem : VideoMemory
         PORT MAP (
         clka => CLK100MHZ,
         wea => wea,
         addra => addra,
         dina => dina,
         douta => open,
         --De klok geeft de snelheid waarmee we gaan uitlezen
         clkb => pixelclock,
         web => "0",--write enable b kant we gaan nooit schrijven langs de b kant
         --Aan addres B kunnen we met een 19 bit std logic vector gaan uitlezen uit het geheugen
         addrb => tellerdata,
         dinb => "000",--niet nodig
         --we lezen de poort doutb (waar de data van het geheugen staat) we zetten het in signaal doutb.
         doutb => doutb
       );
--      VideoMem2 : VideoMemory
--      PORT MAP (
--        clka => CLK100MHZ,
--        wea => wea2 ,
--        addra => addra2,
--        dina => dina2,
--        douta => open,
--        --De klok geeft de snelheid waarmee we gaan uitlezen
--        clkb => pixelclock,
--        web => "0",
--        --Aan addres B kunnen we met een 19 bit std logic vector gaan uitlezen uit het geheugen
--        addrb => tellerdata2,
--        dinb => "000",
--        --we lezen de poort doutb (waar de data van het geheugen staat) we zetten het in signaal doutb.
--      doutb => doutb2
--    );
                
   --port map van de fifo
        fifop : TriangleFifo
        PORT MAP (
           wr_en=>wr_en,
           din=>din,
           dout=>dout,
           rd_en=>rd_en,
           full=>full,
           clk=>CLK100MHZ,
           srst=>'0',
           empty => empty
            );
             
 
               --de sturing van het vga scherm we gaan uit het geheugen uitlezen om dan vanuit deze gegevens het scherm aan te sturen
               pUpdateDisplay : process(x,y,Write,doutb)
               begin            
                   VGA_R <= "0000";
                   VGA_G <= "0000";
                   VGA_B <= "0000";
                 if (write='1') then
                 tel<=(y*640)+x;
                 tellerdata<=std_logic_vector(to_unsigned(tel,19));
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
                end process;
                
                
            
            
 --Werkt         
 lfsrp: process(CLK100MHZ) begin
                if rising_edge(CLK100MHZ) then
                                for I in 1 to 56
                                loop
                                    qs(I) <= qs(I-1);
                                end loop;
                                
                                qs(0) <= ((qs(15) xor qs(13)) xor qs(12)) xor qs(10);
                            end if;
                    --pas na de klokflank zullen al deze waarde worden doorgegeven
                end process;   
                
                
                
fifoAkant:process(CLK100MHZ) begin
if(rising_edge(CLK100MHZ)) then 
 case State is 
          when start=>
          if(full='0' and (qs(56 downto 48)<"111100000") and (qs(47 downto 39)<"111100000")and (qs(38 downto 30)<"111100000") and (qs(29 downto 20)<"1010000000") and (qs(19 downto 10)<"1010000000")and (qs(9 downto 0)<"1010000000"))then
            wr_en<='1';
            if(newframetel<aantaldriehoeken) then
                newframe<="0";
                din<=((qs)&"0"&newframe);
                newframetel<=newframetel+1;
            
            else
                newframe<="1";
                din<=( (qs)&"0"&newframe);
                newframetel<=1;
            end if;
            state<=twee;
          else
            wr_en<='0';
          end if;
          when twee=>
            wr_en<='0';
            state<=start;
    end case;
 end if;
end process;


--fifoBkant:process(CLK100MHZ) begin
--if(rising_edge(CLK100MHZ))then
--    case bstate is
--    when start=>
--        if(empty='0' and klaarvoordata='1')then
--        rd_en<='1';
--        Bstate<=wachten;
--        klaarvoordata<='0';
--        end if;
--    when wachten=>
--        rd_en<='0';
--        --dout uitlezen nu
--        recentstedata<=dout;
--        
--        Bstate<=start;
--    end case;
--end if; 
--end process;
--

geheugen:process(CLK100MHZ)begin
if(rising_edge(CLK100MHZ))
         then
                
case g1_State is
     when start=> 
                --werkt scherm wit maken
              wea<="1";
              addra <= std_logic_vector(to_unsigned(to_integer(unsigned(addra))+1,19));
              if addra >="1001011000000000000" then
                 addra<="0000000000000000000";
                 g1_State <= varinlezen;
                 schermwit<='1';
                 wea<="0";
                 klaarvoordata<='1';
              end if;
              dina<="111";
              --Alles wit maken Rood aan Groen aan Blauw aan
              
     when lijnophalen =>
              --
              if(empty='0')then
                rd_en<='1';
                g1_State<=lijnophalen2;
              end if;
    when lijnophalen2 =>
        rd_en<='0';
       --dout uitlezen nu
       recentstedata<=dout;
       g1_State<=varinlezen;
     when varinlezen =>
        wea<="0";
  
               --nu kunnen we beginnen met het bresenham algoritme door lijnen in te lezen en ze naar het breseham algoritme te schrijven
                  startbres<='1';
                        if (tellerdriehoek=0)then--punt 1 naar 2
                            sx <= to_integer(unsigned(recentstedata(9 downto 0))); 
                            sy <= to_integer(unsigned(recentstedata(38 downto 30))); 
                            x0 <= recentstedata(9 downto 0);--punt1
                            y0 <= recentstedata(38 downto 30);
                            x1 <= recentstedata(19 downto 10);--punt 2
                            y1 <= recentstedata(47 downto 39);
                            g1_State <= beginnen;
                            end if;
                        if (tellerdriehoek=1)then--punt 1 naar 3
                            sx <= to_integer(unsigned(recentstedata(9 downto 0))); 
                            sy <= to_integer(unsigned(recentstedata(38 downto 30))); 
                            x0 <= recentstedata(9 downto 0);--punt 1
                            y0 <= recentstedata(38 downto 30);
                            x1 <= recentstedata(29 downto 20);--punt 3
                            y1 <= recentstedata(56 downto 48);
                            g1_State <= beginnen;
                            end if;
                        if (tellerdriehoek=2)then--punt 2 naar 3
                            sx <= to_integer(unsigned(recentstedata(19 downto 10))); 
                            sy <= to_integer(unsigned(recentstedata(47 downto 39))); 
                            x0 <= recentstedata(19 downto 10);--punt 2
                            y0 <= recentstedata(47 downto 39);
                            x1 <= recentstedata(29 downto 20);--punt 3
                            y1 <= recentstedata(56 downto 48);
                            
                            g1_State <= beginnen;
                            
                            end if;
                      when beginnen =>            
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
                             g1_State <= Berekenerror;
                      --er is een apparte state voor het berekenen van een error omdat pas na een klokflank de waarde wordt toegekened
                      --en we hebben de berekening van het verschil van dx en dy nodig voor verder te gaan
                      when Berekenerror =>
                             err <= dx - dy;
                             --we gaan naar de volgende state
                             g1_State <= change_e2;       
                      when change_e2 =>   
                      --we berekenen de error 2       
                             e2<=err*2;   
                             wea<="0"; 
                             --nu gaan we tekenen
                             busy <= '1'; --plot='1'                 
                             g1_State <= Drawing;
                      when Drawing =>
                            --als deze if waar is zijn we aangekomen in het eindpunt en hoeven we dus niet verder te gaan
                       if sx=to_integer(unsigned(x1)) and sy=to_integer(unsigned(y1)) then 
                           --De lijn is getekend
                           
                           if(tellerdriehoek=2)then
                              tellerdriehoek<=0;
                              busy <='0';
                              startbres<='0';
                              g1_State <= Done;
                           else
                              tellerdriehoek<=tellerdriehoek+1;
                              klaarvoordata<='0';
                              g1_State <=varinlezen;
                           end if;
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
                                 wea<="1";
                                 addra<=std_logic_vector(to_unsigned(sx+(sy*640),19));
                                 dina<="100";
                                 
                                 busy<='0';
                                 startbres<='0';
                                 --we gaan terug error 2 berekenen want err is aangepast
                              g1_State <= change_e2;
                          end if; 
                      when Done =>    
                            wea<="0";
                            dina<="111";
                          if startbres='1' then
                          
                          dina<="111";
                              g1_State <= beginnen;
                          end if; 
                          
                                
      end case;
   end if; 
  
               
end process;


end Behavioral;
