library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux2 is
    Port ( dpin : in  STD_LOGIC_VECTOR (3 downto 0);
           dp : out  STD_LOGIC;
           lk : in  STD_LOGIC_VECTOR (1 downto 0));
end mux2;

architecture Behavioral of mux2 is

begin

dp<= dpin(0) when lk="00" else
     dpin(1) when lk="01" else
	  dpin(2) when lk="10" else
	  dpin(3) when lk="11";
	  

end Behavioral;

