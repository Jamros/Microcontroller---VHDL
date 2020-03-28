
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity transkoder is
    Port ( lk : in  STD_LOGIC_VECTOR (1 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end transkoder;

architecture Behavioral of transkoder is

begin

an<="1110" when lk="00" else
    "1101" when lk="01" else
	 "1011" when lk="10" else
	 "0111" ;

end Behavioral;

