library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity scan4Digit is
			Port ( digit0 : in STD_LOGIC_VECTOR (6 downto 0); --7 Bits
					 digit1 : in STD_LOGIC_VECTOR (6 downto 0);
					 digit2 : in STD_LOGIC_VECTOR (6 downto 0);
					 digit3 : in STD_LOGIC_VECTOR (6 downto 0);
					 clock : in STD_LOGIC;
				    an : out STD_LOGIC_VECTOR (3 downto 0); --7 segments display
					 ca : out STD_LOGIC;
					 cb : out STD_LOGIC;
					 cc : out STD_LOGIC;
				    cd : out STD_LOGIC;
				    ce : out STD_LOGIC;
					 cf : out STD_LOGIC;
					 cg : out STD_LOGIC);
end scan4Digit;

architecture Behavioral of scan4Digit is
signal iCount16: std_logic_vector (15 downto 0) := (others=>'0'); --16 bits in total for one display segment= 0000 0000 0000 0000 =16 bits
signal iDigitOut: std_logic_vector (6 downto 0);  --We displaing only 7 segments, so 7 bits 

begin
-- Generate the scan clock 50MHz/2^16 (763Hz) Meaning our clock is a 50MHz clock, then we going to do clock divider, we using 16 bits
process(Clock)  --define clock in the sensitiviy list
begin
	if Clock'event and Clock='1' then  --At clock rising edge
	iCount16 <= iCount16 + '1';  --Keep counting, 0000 0000 0000 0000,0000 0000 0000 0001 etc....
	end if;
end process;

--Scan four digits to four 7-segment display, we taking only the MSB 
with iCount16 (15 downto 14) select  --We total have 16 bits from 0....16, we only take the last 2 bits which are 15 and 14 (2 bits)
	  iDigitOut <= Digit0 when "00", -- since we only looking for 2 bits now, so we can just focus on the last 2 digits that we desired
	  Digit1 when "01", -- These process is where we keep the data and then display them out on the control in the nxt process
	  Digit2 when "10", --If is '10', then we connect it to Digit2, same applied to the following one	
	  Digit3 when "11", -- All this process is just to keep the data and display in the controller later
	  Digit0 when others;
	
with iCount16 (15 downto 14) select  --This is the controller focus on the last 2 bits meaning within the same period of time when storing the last 2 bits, they are connected 
		An <= "1110" when "00", -- Here actually is meaning only the first LED is turn on like what written in notes, this display only 'D'
				"1101" when "01", -- The process where we can control which LED to display the 2 F 9 D, this display only '9'
				"1011" when "10", -- this display only 'F'
				"0111" when "11", -- this display only '2'
				"1110" when others;
		Ca <= iDigitOut(6);  --iDigitOut will give to all the other except An, from Ca to Cg is 7 segments
		Cb <= iDigitOut(5);  --Taking the fifth bit
		Cc <= iDigitOut(4);  
		Cd <= iDigitOut(3);
		Ce <= iDigitOut(2);
		Cf <= iDigitOut(1);
		Cg <= iDigitOut(0);
end Behavioral;
