library ieee;
use ieee.std_logic_1164.all;

entity TB_TopLevelRS232 is
end TB_TopLevelRS232;

architecture behav of TB_TopLevelRS232 is

component TopLevelRS232
	port( Reset, Send, Rxd: in std_logic;
			SystemClock: in std_logic;
			DataIn1: in std_logic_vector (7 downto 0);
			An: out std_logic_vector (3 downto 0);
			Ca, Cb, Cc, Cd, Ce, Cf, Cg: out std_logic;
			Txd: out std_logic
 );
end component;

--Input signals
signal TB_Reset, TB_Send, TB_Rxd, TB_SystemClock : std_logic;
signal TB_DataIn1 : std_logic_vector(7 downto 0) ;

--Output signals
signal TB_an : std_logic_vector (3 downto 0);
signal TB_ca, TB_cb, TB_cc, TB_cd, TB_ce, TB_cf, TB_cg : std_logic;
signal TB_Txd : std_logic;

 -- Clock period definitions
constant TB_Clock16x_period : time := 6.5 us;

begin
-- unit uder test
UUT : TopLevelRS232 port map(
		Reset => TB_Reset,
		Send => TB_Send,
		Rxd => TB_Rxd,
		SystemClock => TB_SystemClock,
		DataIn1 => TB_dataIn1,
		An => TB_an,
		Ca => TB_ca,
		Cb => TB_cb,
		Cc => TB_cc,
		Cd => TB_cd,
		Ce => TB_ce,
		Cf => TB_cf,
		Cg => TB_cg,
		Txd => TB_Txd);
		
-- produce clock signal
process
	begin
	TB_systemclock <= '1';
	wait for TB_Clock16x_period/2;
	TB_systemclock <= '0';
	wait for TB_Clock16x_period/2;
end process;

-- produce reset signal
process
	begin
	TB_reset <= '1';
	wait for 1.5*TB_Clock16x_period; --Takes 9.75 us for TB-reset signal to change from 1 to 0
	TB_reset <= '0';
	wait;
end process;

-- produce Signal
process
						begin
						TB_Rxd <= '1'; --Initial state
						wait for 5.5*TB_Clock16x_period;
						TB_Rxd <= '0'; -- Start bit
						wait for 16*TB_Clock16x_period;  --this is hexa 62
						TB_Rxd <= '0'; -- Bit 0
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '1'; -- Bit 1
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '0'; -- Bit 2
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '0'; -- Bit 3
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '0'; -- Bit 4
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '1'; -- Bit 5
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '1'; -- Bit 6
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '0'; -- Bit 7        --MSB
						wait for 16*TB_Clock16x_period;
						TB_Rxd <= '1'; -- Stop bit
						wait for 300*TB_Clock16x_period; --Here just stop for longer period to receive second sets of data
						TB_rxd <= '0'; -- Start bit
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 0         --LSB
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 1
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 2
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 3	
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 4
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 5
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 6
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 7         --MSB Read from here, so it is 10000011
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Stop bit
						wait for 16*TB_Clock16x_period;
						wait;
				end process;

-- produce Send signal
process
	begin
	TB_Send <= '0';
   wait for 300*TB_Clock16x_period;   --Pulse to trigger
   TB_Send <= '1';						  --Click the SEND button for txd to be triggered
   wait for 10*TB_Clock16x_period;   --Need longer period for data to be transmistted
	TB_Send <= '0';
   wait for 300*TB_Clock16x_period;   --Pulse to trigger
   TB_Send <= '1';
   wait for 10*TB_Clock16x_period;   --Need longer period for data to be transmistted
	TB_Send <= '0';
	wait;
end process;

-- Send dataIn for Txd to be triggered
	stim_proc: process
   begin
		  TB_DataIn1 <= "00001111";			 --First data in
        wait for 400*TB_Clock16x_period;		  
		  TB_DataIn1 <= "01001001";			 --Second data
        wait;
   end process;
end behav;
