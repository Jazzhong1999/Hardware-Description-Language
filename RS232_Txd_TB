LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_Rs232Txd IS                                                    --[SEQUENTIAL CHECKING]
END TB_Rs232Txd;																			--RST, CLK16x, Send etc, clk1xenable, count, clk1x, shift, count, stop bit
 
ARCHITECTURE behavior OF TB_Rs232Txd IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Rs232Txd
    PORT(
         Reset : IN  std_logic;
         Send : IN  std_logic;
         Clock16x : IN  std_logic;
         DataIn1 : IN  std_logic_vector(7 downto 0); --Come in PARALLELY
         Txd : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal TB_Reset : std_logic := '0';
   signal TB_Send : std_logic := '0';
   signal TB_Clock16x : std_logic := '0';
   signal TB_DataIn1 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal TB_Txd : std_logic;

   -- Clock period definitions
   constant TB_Clock16x_period : time := 6.5 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Rs232Txd PORT MAP (
          Reset => TB_Reset,
          Send => TB_Send,
          Clock16x => TB_Clock16x,
          DataIn1 => TB_DataIn1,
          Txd => TB_Txd
        );

   -- Clock process definitions
   Clock16x_process :process
   begin
		TB_Clock16x <= '0';
		wait for TB_Clock16x_period/2;
		TB_Clock16x <= '1';
		wait for TB_Clock16x_period/2;
   end process;
	
	-- produce reset signal
	process
	begin
	wait for 1.5*TB_Clock16x_period;
	TB_reset <= '1';
	wait for 1.5*TB_Clock16x_period; --Takes 9.75 us for TB-reset signal to change from 1 to 0
	TB_reset <= '0';
	wait;
	end process;
	
-- DataIn Stimulus process
--   process
--   begin
--		  TB_DataIn <= "00001111";
--        wait for 100*TB_Clock16x_period;
--        TB_DataIn <= "01001001";
--        wait for 200*TB_Clock16x_period;
--      wait;
--   end process;
	
   --Send Stimulus process
   stim_proc: process
   begin
	
		  TB_DataIn1 <= "00001111";				 --First data
        wait for TB_Clock16x_period;	
        TB_Send <= '1';
        wait for 16*TB_Clock16x_period;    --Pulse to trigger
        TB_Send <= '0';
        wait for 300*TB_Clock16x_period;   --Need longer period to send data
		  
		  TB_DataIn1 <= "01001001";				--Second data
        wait for TB_Clock16x_period;
        TB_Send <= '1';
        wait for 16*TB_Clock16x_period;
        TB_Send <= '0';
        wait for 300*TB_Clock16x_period;
        wait;
   end process;

END;
