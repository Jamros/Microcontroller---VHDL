library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity led is
    Port ( clk : in  STD_LOGIC;
           btn0 : in  STD_LOGIC;
           SEG : out  STD_LOGIC_VECTOR (7 downto 0);
			  AN: out std_logic_vector (3 downto 0) );
end led;

architecture Behavioral of led is

	component  basic_cpu is
		Port ( CLK_in : in  STD_LOGIC;
           reset_cpu : in  STD_LOGIC;
			  GPIOA : out  STD_LOGIC_VECTOR (7 downto 0);
			  GPIOB : out STD_LOGIC_VECTOR (7 downto 0);
			  GPIOC : out STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component sterownik is
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
	end component;


signal tmp_gpioa: STD_LOGIC_VECTOR (7 downto 0);
signal tmp_gpiob: STD_LOGIC_VECTOR (7 downto 0);
signal tmp_gpioc: STD_LOGIC_VECTOR (7 downto 0);
	
begin
sterownik1: sterownik port map  (x0=> tmp_gpioa(3 downto 0), x1=> tmp_gpioa(7 downto 4), 
											x2=> tmp_gpiob(3 downto 0), x3=> tmp_gpiob(7 downto 4), 
											en=> tmp_gpioc(3), dp=> tmp_gpioc(7 downto 4),
											clk_st=> clk, reset_st=> btn0, an=> an, seg=>seg);
basic_cpu1 : basic_cpu port map (clk_in => clk, reset_cpu=> btn0, gpioa => tmp_gpioa, 
											gpiob => tmp_gpiob, gpioc => tmp_gpioc);


end Behavioral;

