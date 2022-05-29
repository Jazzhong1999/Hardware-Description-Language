library ieee;
use ieee.std_logic_1164.all;           
use ieee.std_logic_unsigned.all;

entity Rs232Txd is
port( Reset, Send, Clock16x: in std_logic;
		DataIn1: in std_logic_vector(7 downto 0); --Data receive at one time
		Txd: out std_logic);
end Rs232Txd;

architecture Rs232Txd_Arch of Rs232Txd is
attribute enum_encoding: string;

-- state definitions
type stateType is (stIdle, stData, stStop, stTxdCompleted);  --Define our state type, we have 4 states in total
attribute enum_encoding of stateType: type is "00 01 11 10";
signal presState: stateType;
signal nextState: stateType;
signal iSend1, iSend2, iReset, iClock1xEnable, iEnableTxdBuffer, iEnableShift : std_logic;
signal iTxdBuffer: std_logic_vector (8 downto 0);
signal iClockDiv: std_logic_vector (3 downto 0);
signal iClock1x: std_logic;
signal iNoBitsSent: std_logic_vector (3 downto 0);

begin
	process (Clock16x) --Firstly we need to define the function for clock16x at 16*9600 Baud rate = 153600
	begin
		if Clock16x'event and Clock16x = '1' then  --at clock rising edge
 			if Reset = '1' or iReset = '1' then     --everything reset
				iClock1xEnable <= '0';
				iSend1 <= '0';				--Initial at '0', so later we can detect rising edge
				iSend2 <= '0';				--To Avoid UNDEFINE during the initial state
				iClockDiv <= (others=>'0');        --Let others to be zero as initial state when RESET is triggered
			else
				iSend1 <= Send;     	--Else, if there is NO RESET, Passing/Assigning data from one stage to another
				iSend2 <= iSend1;
				
				--Gated clock
				if iClock1xEnable = '1' then --Now still is At rising edge, and if the enable is 1 which we provided during the TBench
					iClockDiv <= iClockDiv + '1'; --clock will keep counting, then later use to divide at iclock1x
				elsif iSend1 = '1' and iSend2 = '0' then --This is to detect the rising edge
					iClock1xEnable <= '1';				
				end if;
			end if;
		end if;
	end process;
	iClock1x <= iClockDiv(3);  --After done count, then divide the code

	process (iClock1xEnable, iClock1x) --Define internal clock after the division (actual clock)
	begin
		if iClock1xEnable = '0' then    --If clock is not enabled, define everything as initial state
			iNoBitsSent <= (others=>'0');--Number of bits send is ZERO, system be in IDLE state
			iEnableShift <= '0';
			iTxdBuffer <= (others=> '1');			
			presState <= stIdle;
			Txd <= '1';  					  --Not transmiting any data 
			
		elsif iClock1x'event and iClock1x = '1' then --If the actual clock is at rising edge is counting meaning got info/signal 
				presState <= nextState;
				if iEnableShift = '1' then
					Txd <= iTxdBuffer(0);
					iNoBitsSent <= iNoBitsSent + '1';        --System started to assign number of bits, and prepare for next state
					iTxdBuffer <= '1' & iTxdBuffer(8 downto 1); --Shift 1 infront (MSB)
										 
				elsif iEnableShift = '0' then  --NO shift allows
					iTxdBuffer <= DataIn1 & '0'; --Add a '0' infront the dataIn, that is why the dataIn becomes 000011110, but notice 
														  --we also not yet start the bit, the start bit only drop when 0001 = 1 at iNoBitsSent
					Txd <= iTxdBuffer(0);        --Then after we add 000011110, this resulting it to enter the next cycle
					iEnableshift <= '1';			  --So now at this case, we now allows to shift
				else
					Txd <= '1'; 					  --Otherwise, if does not meet the above conditions, we let txd remain IDLE
				end if;
		end if;
	end process;

	process (presState, iClock1xEnable, iNoBitsSent)
	begin
		iReset <= '0';
      iEnableTxdBuffer <= '0';
		
		case presState is
        when stIdle =>
            if iClock1xEnable = '1' then
                nextState <= stData;
            else
                nextState <= stIdle;
				end if;
        when stData =>
				if iNoBitsSent = "1001" then --The ninth bit, which is the parity bit used for checking, 1001=9dec
               nextState <= stStop;
					iEnableTxdBuffer <= '0';
            else
					iEnableTxdBuffer <= '1';
               nextState <= stData;
            end if;
        when stStop =>       		--10 bits
				 nextState <= stTxdCompleted;
        when stTxdCompleted =>   --11 bits
				 iReset <= '1';  --After one cycle is done then we should RESET the internal system
	   		 nextState <= stIdle;
     end case;
	end process;
end Rs232Txd_Arch;
