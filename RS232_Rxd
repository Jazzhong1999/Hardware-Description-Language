library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rs232Rxd is
port( Reset, Clock16x, Rxd: in std_logic;
		DataOut1: out std_logic_vector (7 downto 0));
end Rs232Rxd;

architecture Rs232Rxd_Arch of Rs232Rxd is
attribute enum_encoding: string;

-- state definitions 
type stateType is (stIdle, stData, stStop, stRxdCompleted);
attribute enum_encoding of statetype: type is "00 01 11 10";
signal presState: stateType;
signal nextState: stateType;
signal iReset, iRxd1, iRxd2, iClock1xEnable, iClock1x, iEnableDataOut: std_logic ;
signal iClockDiv: std_logic_vector (3 downto 0) ;
signal iDataOut1, iShiftRegister: std_logic_vector (7 downto 0) ;
signal iNoBitsReceived: std_logic_vector (3 downto 0) ;

begin
	process (Clock16x) --Firstly we need to define the function for clock16x at 16*9600 Baud rate = 153600
	begin
		if Clock16x'event and Clock16x = '1' then --At rising edge (This process we must use nested rule to avoid errors in future)
			if Reset = '1' or iReset = '1' then --the i is refer to internal signal
				iRxd1 <= '1'; --Meaning no receiving any data, always at 1
				iRxd2 <= '1';
				iClock1xEnable <= '0'; --Nothing needed to be enable during RESET
				iClockDiv <= (others=>'0'); --Nothing to divide during RESET, so no any counting needed too
			else
				iRxd1 <= Rxd; --Else, if there is NO RESET, Passing/Assigning data from one stage to another
				iRxd2 <= iRxd1;
						
				if iClock1xEnable = '1' then --Now still is At rising edge, and if the enable is 1 which we provided during the TBench
					iClockDiv <= iClockDiv + '1'; --clock will keep counting, then later use to divide at iclock1x
				elsif iRxd1 = '0' and iRxd2 = '1' then --This is to detect the falling edge,wrote in the notes
					iClock1xEnable <= '1';  --If detected falling edge, then we will enable the clock to count (start bit)
				end if;
			end if;
		end if;
	end process;
	--Generation of Rxd clock
	iClock1x <= iClockDiv(3);  --Indicating the actual clock, 3,2,1,0 = 4 bits, 16 = 2^4, so after divided 4 bits, 
									   --we can get the actual one
										
	process (iClock1xEnable, iClock1x) --We added this two into the sensitivity list to define them since the above will trigger them
												--and also the above we already defined for the clock16x, now we should define the internal signal
	begin										  
		if iClock1xEnable = '0' then   --If no clock is enabled
			iNoBitsReceived <= (others=>'0'); --number of bits receive equal zero, meaning nothing to be receive
			presState <= stIdle;  --Then will be at the idle state, which later we will also need to define present states
		elsif iClock1x'event and iClock1x = '1' then --If the actual clock is at rising edge is counting meaning got info/signal 
			iNoBitsReceived <= iNoBitsReceived + '1'; --coming in, then it will keep on counting
			presState <= nextState;
		end if;
		if iClock1x'event and iClock1x = '1' then  --Since here already indiciated signal/data received
			if iEnableDataOut = '1' then  --Here we need to set it t'1' to trigger to enable the data to be send out
				iDataOut1 <= iShiftRegister; --send out the stored data
			else 
				iShiftRegister <= Rxd & iShiftRegister(7 downto 1);  --If data is not enable to send out, then it will keep on 				end if;																  --continue storing/accumulating until, then of cuz we need
			end if;
		end if;
	end process;
	DataOut1 <= iDataOut1; --Sending internal data to the true output
	
	process (presState, iClock1xEnable, iNoBitsReceived) --Here we define the state, into the deeper and deeper variable
	begin
-- signal defaults
		iReset <= '0';  --Here is the inital value is zero because at above we only declared them without giving a initial value
		iEnableDataOut <= '0';  --Here is the initial value is zero
		case presState is --Define present state
			when stIdle =>
				if iClock1xEnable = '1' then --If is idle, but enable is allow, then system can move to next state
					nextState <= stData; --Next state go to data state which we will define later
				else
					nextState <= stIdle; --else, if enable is not allow, then remain at idle state
				end if;
			when stData =>            	--Now here we defining the data state
				if iNoBitsReceived = "1001" then --The ninth bit, which is the parity bit used for checking, 1001=9dec
					iEnableDataOut <= '1';  --then the data can be send out, cuz done checked
					nextState <= stStop; -- Stop the system (Stop bit) to start the next cycle 
				else
					iEnableDataOut <= '0'; --But if data is not enable to send out, then next state continue at storing data set
					nextState <= stData;
				end if;
			when stStop =>  --Define stop bit
				nextState <= stRxdCompleted; --Indicated the receiving cycle is completed 
			when stRxdCompleted =>  --Then here we define the complete receive cycle
				iReset <= '1';  --After one cycle is done then we should RESET the internal system
				nextState <= stIdle;  --Go back to the idle state to await to receive the new data/signal
		end case;
	end process;
end Rs232Rxd_Arch;
