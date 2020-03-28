
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux1 is
    Port ( x0 : in  STD_LOGIC_VECTOR (3 downto 0);
           x1 : in  STD_LOGIC_VECTOR (3 downto 0);
           x2 : in  STD_LOGIC_VECTOR (3 downto 0);
           x3 : in  STD_LOGIC_VECTOR (3 downto 0);
           lk : in  STD_LOGIC_VECTOR (1 downto 0);
           x : out  STD_LOGIC_VECTOR (3 downto 0));
end mux1;

architecture Behavioral of mux1 is

begin

x<= x0 when lk="00" else
    x1 when lk="01" else
	 x2 when lk="10" else
	 x3 when lk="11";

end Behavioral;

