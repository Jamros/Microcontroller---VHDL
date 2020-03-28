library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity basic_cpu is
	 Generic (ROM_size : natural := 256;
	          RAM_size : natural := 64;
				 IO_size : natural := 8); 
    Port ( CLK_in : in  STD_LOGIC;
           reset_cpu : in  STD_LOGIC;
			  GPIOA : out  STD_LOGIC_VECTOR (7 downto 0);
			  GPIOB : out STD_LOGIC_VECTOR (7 downto 0);
			  GPIOC : out STD_LOGIC_VECTOR (7 downto 0)); 
end basic_cpu;

architecture Behavioral of basic_cpu is

type ROM_def is array (0 to ROM_size) of std_logic_vector(15 downto 0);
type RAM_def is array (0 to RAM_size) of std_logic_vector(7 downto 0);
type IO_def is array (0 to IO_size) of std_logic_vector(7 downto 0);

-- Instructions
constant nop      	: std_logic_vector(7 downto 0) := "00000000";
constant load_v   	: std_logic_vector(7 downto 0) := "00000001";
constant load     	: std_logic_vector(7 downto 0) := "00000010";
constant loadw    	: std_logic_vector(7 downto 0) := "00000011";
constant load_a   	: std_logic_vector(7 downto 0) := "00000100";
constant loadw_a  	: std_logic_vector(7 downto 0) := "00000101";
constant store    	: std_logic_vector(7 downto 0) := "00000110";
constant storew   	: std_logic_vector(7 downto 0) := "00000111";
constant store_a  	: std_logic_vector(7 downto 0) := "00001000";
constant storew_a 	: std_logic_vector(7 downto 0) := "00001001";
constant add_v    	: std_logic_vector(7 downto 0) := "00001010";
constant add      	: std_logic_vector(7 downto 0) := "00001011";
constant addw     	: std_logic_vector(7 downto 0) := "00001100";
constant sub_v    	: std_logic_vector(7 downto 0) := "00001101";
constant sub      	: std_logic_vector(7 downto 0) := "00001110";
constant subw     	: std_logic_vector(7 downto 0) := "00001111";
constant c_not    	: std_logic_vector(7 downto 0) := "00010000";
constant c_and    	: std_logic_vector(7 downto 0) := "00010001";
constant c_or     	: std_logic_vector(7 downto 0) := "00010010";
constant c_xor    	: std_logic_vector(7 downto 0) := "00010011";
constant cmp_v    	: std_logic_vector(7 downto 0) := "00010100";
constant cmp      	: std_logic_vector(7 downto 0) := "00010101";
constant jmp      	: std_logic_vector(7 downto 0) := "00010110";
constant jmpz     	: std_logic_vector(7 downto 0) := "00010111";
constant jmpnz    	: std_logic_vector(7 downto 0) := "00011000";
constant jmpc     	: std_logic_vector(7 downto 0) := "00011001";
constant jmpnc    	: std_logic_vector(7 downto 0) := "00011010";
constant store_IO 	: std_logic_vector(7 downto 0) := "00011011";
constant load_IO		: std_logic_vector(7 downto 0) := "00011011";
constant sla_IO		: std_logic_vector(7 downto 0) := "00011100";
constant store_IO_bit: std_logic_vector(7 downto 0) := "00011101";
constant load_IO_bit	: std_logic_vector(7 downto 0) := "00011110";


-- Adress Registers
constant IO_GPIOA		 : std_logic_vector(7 downto 0) := x"00";
constant IO_GPIOB		 : std_logic_vector(7 downto 0) := x"01";
constant IO_GPIOC		 : std_logic_vector(7 downto 0) := x"02";
constant IO_TIM_CNT   : std_logic_vector(7 downto 0) := x"03";
constant IO_TIM_ARR   : std_logic_vector(7 downto 0) := x"04";
constant IO_TIM_PSC_L : std_logic_vector(7 downto 0) := x"05";
constant IO_TIM_PSC_H : std_logic_vector(7 downto 0) := x"06";
constant IO_TIM_PRO 	 : std_logic_vector(7 downto 0) := x"07";
constant IO_SYS_PSC	 : std_logic_vector(7 downto 0) := x"08";

--Bit Registers in Timer_PRO
constant IO_TIM_PRO_EN  : std_logic_vector(7 downto 0) := x"00";
constant IO_TIM_PRO_INT : std_logic_vector(7 downto 0) := x"01";

-- Adress Register in integer
constant iIO_GPIOA : integer := to_integer(unsigned(IO_GPIOA));
constant iIO_GPIOB : integer := to_integer(unsigned(IO_GPIOB));
constant iIO_GPIOC : integer := to_integer(unsigned(IO_GPIOC));
constant iIO_TIM_CNT : integer := to_integer(unsigned(IO_TIM_CNT));
constant iIO_TIM_PRO : integer := to_integer(unsigned(IO_TIM_PRO));
constant iIO_TIM_ARR : integer := to_integer(unsigned(IO_TIM_ARR));
constant iIO_TIM_PRO_EN : integer := to_integer(unsigned(IO_TIM_PRO_EN));
constant iIO_TIM_PRO_INT : integer := to_integer(unsigned(IO_TIM_PRO_INT));

constant ROM : ROM_def := (LOAD_V & x"A1", 						-- Wpisanie do ACC wartosci d(16)
									STORE_IO & IO_TIM_PSC_L,			-- Wpisanie do PSC wartosci d(16)
									LOAD_V & x"1D",						-- Wpisanie do ACC wartosci d(39)
									STORE_IO & IO_TIM_PSC_H,			-- Wpisanie do PSC wartosci d(39)
								   others => x"0000");
									
signal IO  : IO_def 	:= (others => x"00");
signal RAM : RAM_def := (others => x"00");

signal ACC : std_logic_vector (7 downto 0) := x"00";
signal PC  : integer := 0;
signal SR  : std_logic_vector (7 downto 0) := x"00"; --bit 1=Z, 0=C
signal tmp: std_logic_vector (7 downto 0) := x"00";

---------
signal clk_cpu: std_logic := '0';
signal slow_count: integer range 0 to 255 := 1;

signal prs_TIM_clock: std_logic := '0';
signal prs_TIM_count: integer range 0 to 65535 := 0;

signal sTIM_CNT: std_logic_vector (7 downto 0);
signal sTIM_INT_BIT : std_logic;
signal IO_PERP_SAVE_EN : std_logic := '1';

signal reset_cpu_in: std_logic := reset_cpu;

begin

slow_clock_process: process(clk_in)
variable SYS_PRS: integer := to_integer(unsigned((IO(to_integer(unsigned(IO_SYS_PSC))))));
begin
	if (rising_edge(clk_in)) then
		slow_count <= slow_count + 1;
		if (SYS_PRS = 0) then
			clk_cpu <= clk_in;
			if (slow_count = 2*SYS_PRS) then
				slow_count <= 1;
				clk_cpu <= '0';
			elsif (slow_count = (SYS_PRS)) then
				clk_cpu <= '1';
			end if;
		end if;
	end if;	
end process slow_clock_process;

---------TIM-preskaler
preskaler: process (clk_in)
variable TIM_PRS: std_logic_vector(15 downto 0):= (IO(to_integer(unsigned(IO_TIM_PSC_H))) & IO(to_integer(unsigned(IO_TIM_PSC_L))));
variable TIM_PRS_INT: integer := to_integer(unsigned(TIM_PRS));
begin
	if (rising_edge(clk_in)) then
		prs_TIM_count <= prs_TIM_count + 1;
		if (prs_TIM_count = 2*TIM_PRS_INT) then
			prs_TIM_count <= 0;
			prs_TIM_clock <= '0';
		elsif (prs_TIM_count = TIM_PRS_INT) then
			prs_TIM_clock <= '1';
		end if;
	end if;	
end process preskaler;


---------Timer do wyswietlacza
timer: process(prs_TIM_clock)

begin
	if reset_cpu = '1' then
		sTIM_CNT <= x"00";
	elsif rising_edge(clk_in) then
		if IO(iIO_TIM_PRO)(iIO_TIM_PRO_EN) = '1' and (unsigned(IO(iIO_TIM_CNT))) < ((unsigned(IO(iIO_TIM_ARR)))) then
			sTIM_CNT <= std_logic_vector(unsigned(sTIM_CNT)+1);
		elsif IO(iIO_TIM_PRO)(iIO_TIM_PRO_EN) = '1' and not ((unsigned(IO(iIO_TIM_CNT))) < (unsigned(IO(iIO_TIM_ARR)))) then
			sTIM_CNT <= x"00";
			sTIM_INT_BIT <= '1';
		end if;
	end if;
end process timer;

IO(iIO_TIM_CNT) <= sTIM_CNT when IO_PERP_SAVE_EN = '1' else (others => 'Z');
IO(iIO_TIM_PRO)(iIO_TIM_PRO_INT) <= sTIM_INT_BIT when IO_PERP_SAVE_EN = '1' else 'Z';
cpu : process (clk_cpu) is

	variable IR : std_logic_vector(15 downto 0);
	variable CMD : std_logic_vector(15 downto 8);
	variable ARG : std_logic_vector(7 downto 0);
	variable ValueInIO : std_logic_vector(7 downto 0);
	variable IO_ADR : std_logic_vector(4 downto 0);
	variable IO_NUM_BIT : std_logic_vector(2 downto 0);

begin
	--        [IR]
	-- [xxxxxxxx xxxxxxxx]
	--     [CMD & ARG] 
	
	IR := ROM(PC)(15 downto 0);
	CMD := IR(15 downto 8);
	ARG := IR(7 downto 0);
	IO_ADR := ARG(7 downto 3);
	IO_NUM_BIT := ARG(2 downto 0);
	
	if reset_cpu = '1' then
		PC <= 0;
		SR <= x"00";
	elsif rising_edge(clk_cpu) then
		IO_PERP_SAVE_EN <= '1';	
------------------ROZKAZY---------------------------
		------01.NOP
		if CMD = nop then
			PC <= PC + 1;
		------02.LOAD_V
		elsif CMD = load_v then
			acc <= ARG;
			PC <= PC + 1;
		------03.LOAD
		elsif CMD = load then
			acc <= RAM(to_integer(unsigned(ARG)));
			PC <= PC + 1;
		------07.STORE
		elsif CMD = store then
			RAM(to_integer(unsigned(ARG))) <= acc;
			PC <= PC + 1;
		------09.STORE_A
		elsif CMD = store_a then
			tmp <= RAM(to_integer(unsigned(ARG)));
			RAM(to_integer(unsigned(tmp))) <= acc;
			PC <= PC + 1;
		------11.ADD_V
		elsif CMD = add_v then
			acc <= std_logic_vector((unsigned(acc)) + unsigned(ARG));
			PC <= PC + 1;
		------21.CMP_V
		elsif CMD = cmp_v then
			if acc = ARG then
				SR(1) <= '1';
			elsif acc < ARG then
				SR(0) <= '1';
			else
				SR(1 downto 0) <= "00";
			end if;
			PC <= PC + 1;
		------23.JMP
		elsif CMD = jmp then
			PC <= to_integer(unsigned(ARG));
		------25.JMPNZ
		elsif CMD = jmpnz then
			if SR(1) = '0' then
				PC <= to_integer(unsigned(ARG));
			else
				PC <= PC + 1;
			end if;
		------28.STORE_IO
		elsif CMD = store_IO then
			IO_PERP_SAVE_EN <= '0';
			
--			IO(to_integer(unsigned(ARG))) <= acc; //Powoduje blad w syntezie przez dodanie TIMERA
			PC <= PC + 1;
		------29.LOAD_IO
		elsif CMD = load_IO then
			acc <= IO(to_integer(unsigned(ARG)));
			PC <= PC + 1;
		------30. SLA_IO - Logical Shift Left in I/O registers with Carry
		elsif CMD = SLA_IO then
			IO_PERP_SAVE_EN <= '0';
			
			ValueInIo := IO(to_integer(unsigned(ARG)));
--			IO(to_integer(unsigned(ARG))) <= ValueInIo(6 downto 0) & ValueInIo(7); //Powoduje blad w syntezie przez dodanie TIMERA
			PC <= PC + 1;
		------31. store_IO_bit
		elsif CMD = store_IO_bit then
			IO_PERP_SAVE_EN <= '0';
			
--			IO(to_integer(unsigned(IO_ADR)))(to_integer(unsigned(IO_NUM_BIT))) <= acc(0); //Powoduje blad w syntezie przez dodanie TIMERA
			PC <= PC + 1;
		------32. load_IO_bit
		elsif CMD = load_IO_bit then
			acc(0) <= IO(to_integer(unsigned(IO_ADR)))(to_integer(unsigned(IO_NUM_BIT)));
			PC <= PC + 1;
		end if;
	end if;
end process;

--IO(iIO_TIM_CNT) <= acc when IO_PERP_SAVE_EN = '0' and ROM(PC)(15 downto 8) = store_IO and ROM(PC)(7 downto 0) = IO_TIM_CNT else (others => 'Z');
IO(to_integer(unsigned(ROM(PC)(7 downto 0)))) <= acc when IO_PERP_SAVE_EN = '0' and ROM(PC)(15 downto 8) = store_IO else (others => 'Z');


GPIOA <= IO(iIO_GPIOA);
GPIOB <= IO(iIO_GPIOB);
GPIOC <= IO(iIO_GPIOC);


end Behavioral;