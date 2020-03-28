LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT led
    PORT(
         clk : IN  std_logic;
         btn0 : IN  std_logic;
         led_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal btn0 : std_logic := '0';

 	--Outputs
   signal led_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: led PORT MAP (
          clk => clk,
          btn0 => btn0,
          led_out => led_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	btn0 <='1';
	 wait for clk_period*2;
	btn0 <='0';
      -- insert stimulus here 

      wait;
   end process;

END;
