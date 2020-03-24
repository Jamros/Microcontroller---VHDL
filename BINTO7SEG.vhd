
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BINTO7SEG is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           dp : in  STD_LOGIC;
           en : in  STD_LOGIC;
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end BINTO7SEG;

architecture Behavioral of BINTO7SEG is

begin
 
seg <= not dp & "1000000" when en='1' and x="0000" else
		 not dp & "1111001" when en='1' and x="0001" else
		 not dp & "0100100" when en='1' and x="0010" else
		 not dp & "0110000" when en='1' and x="0011" else
		 not dp & "0011001" when en='1' and x="0100" else
		 not dp & "0010010" when en='1' and x="0101" else
		 not dp & "0000010" when en='1' and x="0110" else
		 not dp & "1111000" when en='1' and x="0111" else
		 not dp & "0000000" when en='1' and x="1000" else
		 not dp & "0010000" when en='1' and x="1001" else
		 not dp & "0001000" when en='1' and x="1010" else
		 not dp & "0000011" when en='1' and x="1011" else
		 not dp & "1000110" when en='1' and x="1100" else
		 not dp & "0100001" when en='1' and x="1101" else
		 not dp & "0000110" when en='1' and x="1110" else
		 not dp & "0001110" when en='1' and x="1111" else
		     "11111111" ; 
		 



end Behavioral;

