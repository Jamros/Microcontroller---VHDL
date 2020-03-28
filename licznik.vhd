
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity licznik is
    Port ( en : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           res : in  STD_LOGIC;
           lk : out  STD_LOGIC_VECTOR (1 downto 0));
end licznik;

architecture Behavioral of licznik is
signal lkt: std_logic_vector(1 downto 0);

begin

Licznik: process(CLK,RES, en)
begin
	if RES = '1' then
		lkt <="00";
	elsif en='1' then
		
		if rising_edge(CLK) then 
			lkt <= STD_LOGIC_VECTOR(unsigned(lkt) + 1);
		end if;
	end if;
end process;

lk <= lkt;

end Behavioral;

