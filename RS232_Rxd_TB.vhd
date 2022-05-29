LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_Rs232Rxd2 IS
END TB_Rs232Rxd2;
 
ARCHITECTURE behavior OF TB_Rs232Rxd2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Rs232Rxd
    PORT(
         Reset : IN  std_logic;
         Clock16x : IN  std_logic;
         Rxd : IN  std_logic;
         DataOut1 : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
   --Inputs
   signal TB_Reset : std_logic := '0';
   signal TB_Clock16x : std_logic := '0';
   signal TB_Rxd : std_logic := '0';

 	--Outputs
   signal TB_DataOut1 : std_logic_vector(7 downto 0); --8 bits output, this 8 bits containing data receiving contents

   -- Clock period definitions
   constant TB_Clock16x_period : time := 6.5 us; --This is from F = 16x9600 Baud rate = 153600Hz, 1/153600 = 6.5us
																--Meaning this 6.5 us is for 16x, but our Rxd file design got divide into 1x
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Rs232Rxd PORT MAP (
          Reset => TB_Reset,   --Here remember we map the variable into the test bench for testing, so arrow pointing to RIGHT
          Clock16x => TB_Clock16x,
          Rxd => TB_Rxd,
          DataOut1 => TB_DataOut1
        );

-- Produce clock signal
   Clock16x_process :process
   begin
		TB_Clock16x <= '1';
		wait for TB_Clock16x_period/2;
		TB_Clock16x <= '0';
		wait for TB_Clock16x_period/2;
   end process;

-- produce reset signal
process
	begin
	TB_reset <= '1';
	wait for 1.5*TB_Clock16x_period; --9.75 us
	TB_reset <= '0';
	wait;
	end process;

   -- Stimulus process
   stim_proc: process
						begin		
						TB_rxd <= '1';
						wait for 5.5*TB_Clock16x_period; --5.5 x 6.5 us = 35.75 us
						TB_rxd <= '0'; -- Start bit
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 0         --LSB
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 1
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 2
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 3	
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 4
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 5
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Bit 6
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '0'; -- Bit 7         --MSB Read from here, so it is 01100010 
						wait for 16*TB_Clock16x_period;
						TB_rxd <= '1'; -- Stop bit		  --Note that here after STOP BIT, RXD back to state 1
						wait for 30*TB_Clock16x_period; --Here just stop for longer period to receive second sets of data
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
END;
