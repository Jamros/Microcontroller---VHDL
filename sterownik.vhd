library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sterownik is
    Port ( x0 : in  STD_LOGIC_VECTOR (3 downto 0);
           x1 : in  STD_LOGIC_VECTOR (3 downto 0);
           x2 : in  STD_LOGIC_VECTOR (3 downto 0);
           x3 : in  STD_LOGIC_VECTOR (3 downto 0);
           DP : in  STD_LOGIC_VECTOR (3 downto 0);
           EN : in  STD_LOGIC;
           CLK_st : in  STD_LOGIC;
           RESET_st : in  STD_LOGIC;
           AN : out  STD_LOGIC_VECTOR (3 downto 0);
           SEG : out  STD_LOGIC_VECTOR (7 downto 0));
end sterownik;

architecture Behavioral of sterownik is
	component BINTO7SEG is
	Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           dp : in  STD_LOGIC;
           en : in  STD_LOGIC;
           seg : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

	component licznik is
	Port ( en : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           res : in  STD_LOGIC;
           lk : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

	component mux1 is 	
	Port ( x0 : in  STD_LOGIC_VECTOR (3 downto 0);
           x1 : in  STD_LOGIC_VECTOR (3 downto 0);
           x2 : in  STD_LOGIC_VECTOR (3 downto 0);
           x3 : in  STD_LOGIC_VECTOR (3 downto 0);
           lk : in  STD_LOGIC_VECTOR (1 downto 0);
           x : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

	component mux2 is
	Port ( dpin : in  STD_LOGIC_VECTOR (3 downto 0);
           dp : out  STD_LOGIC;
           lk : in  STD_LOGIC_VECTOR (1 downto 0));
end component;

	component transkoder is 
	Port ( lk : in  STD_LOGIC_VECTOR (1 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

signal tmp_lk: std_logic_vector (1 downto 0);
signal tmp_x: std_logic_vector (3 downto 0);
signal tmp_dp: std_logic;

begin

st1: licznik port map (en => en, clk => CLK_st, res => RESET_st, lk => tmp_lk);
st2: mux1 port map (x0 => x0, x1 => x1, x2 => x2, x3 => x3, lk => tmp_lk, x => tmp_x);
st3: mux2 port map (dpin => dp, lk => tmp_lk, dp => tmp_dp);
st4: BINTO7SEG port map (x => tmp_x, dp => tmp_dp, en => en, seg => SEG);
st5: transkoder port map (lk => tmp_lk, an => AN);

end Behavioral;

