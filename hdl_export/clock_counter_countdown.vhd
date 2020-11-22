--------------------------------------------------------------------------------
-- HEIG-VD, institute REDS, 1400 Yverdon-les-Bains
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock_counter is
  port(
  ------------------------------------------------------------------------------
  --Insert input ports below
    enable  : in  std_logic;      
	 clk		: in std_logic;
    reset     : in  std_logic;
	 set_ten_hour	: in std_logic;
	 set_hour	: in std_logic;
	 set_ten_min	: in std_logic;
	 set_min	: in std_logic;
	 set_ten_sec	: in std_logic;
	 set_sec	: in std_logic;
	 increment	: in std_logic;
	 up0_down1	: in std_logic;
  ------------------------------------------------------------------------------
  --Insert ouput ports below
    output_ten_hour     : out  std_logic_vector(1 downto 0);
    output_hour     : out  std_logic_vector(3 downto 0);
	 output_ten_min     : out  std_logic_vector(3 downto 0);
	 output_min     : out  std_logic_vector(3 downto 0);
	 output_ten_sec     : out  std_logic_vector(3 downto 0);
	 output_sec     : out  std_logic_vector(3 downto 0);
	 output_tenth_sec     : out  std_logic_vector(3 downto 0);
	 output_hunderth_sec     : out  std_logic_vector(3 downto 0)
    );
end clock_counter;

--------------------------------------------------------------------------------
--Complete your VHDL description below
architecture type_architecture of clock_counter is
	signal ten_hour     : unsigned(1 downto 0);
	signal hour     : unsigned(3 downto 0);
	signal ten_min     : unsigned(3 downto 0);
	signal min     : unsigned(3 downto 0);
	signal ten_sec     : unsigned(3 downto 0);
	signal sec     : unsigned(3 downto 0);
	signal tenth_sec     : unsigned(3 downto 0);
	signal hunderth_sec     : unsigned(3 downto 0);
begin
	Reg_proc: process(clk, reset)
	begin
		if (reset = '1') then
			ten_hour <= (others => '0');
			hour <= (others => '0');
			ten_min <= (others => '0');
			min <= (others => '0');
			ten_sec <= (others => '0');
			sec <= (others => '0');
			tenth_sec <= (others => '0');
			hunderth_sec <= (others => '0');
			
		elsif (rising_edge(clk) and enable = '1' and up0_down1 = '0') then
			if (hunderth_sec = 9) then -- carry 100th sec
				hunderth_sec <= (others => '0'); 
				if (tenth_sec = 9) then -- carry 10th sec
					tenth_sec <= (others => '0');
					if (sec = 9) then -- carry sec
						sec <= (others => '0');
						if (ten_sec = 5) then -- carry 10s
							ten_sec <= (others => '0');
							if (min = 9) then -- carry 1 min
								min <= (others => '0');
								if (ten_min = 5) then -- carry 10 min
									ten_min <= (others => '0');
									if (hour = 3 and ten_hour = 2) then -- if 24h
										hour <= (others => '0');
										ten_hour <= (others => '0');
									elsif (hour = 9) then -- carry 1h
										ten_hour <= ten_hour + 1;
										hour <= (others => '0');
									else
										hour <= hour + 1; -- increment hour
									end if;
								else
									ten_min <= ten_min + 1; -- increment 10 min
								end if;
							else
								min <= min + 1; -- increment 1 min
							end if;
						else
							ten_sec <= ten_sec + 1; -- increment 10s
						end if;
					else
						sec <= sec + 1; -- increment 1s
					end if;
				else
					tenth_sec <= tenth_sec + 1; -- increment 0.1s
				end if;
			else
				hunderth_sec <= hunderth_sec + 1; -- increment 0.01s
			end if;
		elsif (rising_edge(clk) and enable = '1' and up0_down1 = '1') then
			if (hunderth_sec = 0) then -- carry 100th sec
				hunderth_sec <= to_unsigned(9, 4); 
				if (tenth_sec = 0) then -- carry 10th sec
					tenth_sec <= to_unsigned(9, 4);
					if (sec = 0) then -- carry sec
						sec <= to_unsigned(9, 4);
						if (ten_sec = 0) then -- carry 10s
							ten_sec <= to_unsigned(5, 4);
							if (min = 0) then -- carry 1 min
								min <= to_unsigned(9, 4);
								if (ten_min = 0) then -- carry 10 min
									ten_min <= to_unsigned(5, 4);
									if (hour = 0 and ten_hour = 0) then -- if 24h
										hour <= to_unsigned(3, 4);
										ten_hour <= to_unsigned(2, 2);
									elsif (hour = 0) then -- carry 1h
										ten_hour <= ten_hour - 1;
										hour <= to_unsigned(9, 4);
									else
										hour <= hour - 1; -- increment hour
									end if;
								else
									ten_min <= ten_min - 1; -- increment 10 min
								end if;
							else
								min <= min - 1; -- increment 1 min
							end if;
						else
							ten_sec <= ten_sec - 1; -- increment 10s
						end if;
					else
						sec <= sec - 1; -- increment 1s
					end if;
				else
					tenth_sec <= tenth_sec - 1; -- increment 0.1s
				end if;
			else
				hunderth_sec <= hunderth_sec - 1; -- increment 0.01s
			end if;
		elsif (rising_edge(clk) and increment = '1') then
				if (set_ten_hour = '1') then 
					if (ten_hour = 2) then
						ten_hour <= (others => '0');
					else
						ten_hour <= ten_hour + 1;
					end if;
				elsif (set_hour = '1') then 
					if (hour = 3 and ten_hour = 2) then
						hour <= (others => '0');
					elsif (hour = 9) then
						hour <= (others => '0');
					else
						hour <= hour + 1;
					end if;
				elsif (set_ten_min = '1') then 
					if (ten_min = 5) then
						ten_min <= (others => '0');
					else
						ten_min <= ten_min + 1;
					end if;
				elsif (set_min = '1') then 
					if (min = 9) then
						min <= (others => '0');
					else
						min <= min + 1;
					end if;
				elsif (set_ten_sec = '1') then 
					if (ten_sec = 9) then
						ten_sec <= (others => '0');
					else
						ten_sec <= ten_sec + 1;
					end if;
				elsif (set_sec = '1') then 
					if (sec = 9) then
						sec <= (others => '0');
					else
						sec <= sec + 1;
					end if;
				end if;
		end if;
		
		output_ten_hour <= std_logic_vector(ten_hour);
		output_hour <= std_logic_vector(hour);
	   output_ten_min <= std_logic_vector(ten_min);
	   output_min <= std_logic_vector(min);
	   output_ten_sec <= std_logic_vector(ten_sec);
	   output_sec <= std_logic_vector(sec);
	   output_tenth_sec <= std_logic_vector(tenth_sec);
	   output_hunderth_sec <= std_logic_vector(hunderth_sec);
	end process;
end type_architecture;

