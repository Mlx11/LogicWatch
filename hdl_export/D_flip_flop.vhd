-- VHDL Code for AND gate

-- Header file declaration

library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration

entity cdflipflop is

    port(input : in std_logic;
    		enable : in std_logic;
          clk : in std_logic;
          reset: in std_logic;
          set: in std_logic;
		Y : out std_logic);

end cdflipflop;

-- Architecture definition

architecture cdflipflop_logic of cdflipflop is
	begin
		Reg_Proc: process(clk, reset, set)
	 	begin
	 		if (reset = '1') then
	 			Y <= '0';
	 		elsif (set='1') then
	 			Y <= '1';
	 		elsif (rising_edge(clk) and enable = '1') then
	 			Y <= input;
	 		end if;
	 	end process;
end cdflipflop_logic; 
