library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevelRS232 is
			port ( Rxd: in std_logic;
					 send,Reset: in std_logic;
					 SystemClock: in std_logic;
					 DataIn1: in std_logic_vector (7 downto 0);
					 An: out std_logic_vector (3 downto 0);
					 Ca, Cb, Cc, Cd, Ce, Cf, Cg: out std_logic;
					 Txd: out std_logic
					 );
end TopLevelRS232;

architecture Behavioral of TopLevelRS232 is

component RS232
			port( Reset, Clock16x, Rxd: in std_logic;
			Send: in std_logic;
			DataIn1: in std_logic_vector(7 downto 0);
			DataOut1: out std_logic_vector (7 downto 0);
			Txd: out std_logic);
			end component;
			
component D4to7
port ( Q: in std_logic_vector (3 downto 0);
Seg: out std_logic_vector (6 downto 0));
end component;

component scan4digit
	port ( Digit3, Digit2, Digit1, Digit0: in std_logic_vector(6 downto 0);
			 Clock: in std_logic; An : out std_logic_vector(3 downto 0);
			 Ca, Cb, Cc, Cd, Ce, Cf, Cg: out std_logic);
end component;

signal iClock16x: std_logic;
signal iClock : std_logic;
signal iReset : std_logic;
signal iDigitOut3, iDigitOut2, iDigitOut1, iDigitOut0: std_logic_vector (6 downto 0);
signal iDataOut1: std_logic_vector (7 downto 0);
signal iDataOut2: std_logic_vector (7 downto 0);

begin
	iDataOut2 <= DataIn1; --Assign DataIn to internal DataOut
		iClock16x <= SystemClock;

		U1: RS232 port map (  --This is the combined U1
			Reset => Reset,
			Clock16x => iClock16x,
			Rxd => Rxd,
			Send => Send,
			DataIn1 => DataIn1,
			DataOut1 => iDataOut1,
			Txd => Txd);
		
		U2: D4to7 port map (          --Scan for the first four bits
			Q => iDataOut1(3 downto 0),--4 bits
			Seg => iDigitOut0);
		
		U3: D4to7 port map (				--Scan for the second four bits
			Q => iDataOut1(7 downto 4),
			Seg => iDigitOut1);
			
		U4: D4to7 port map (				--Scan for the third four bits
			Q => iDataOut2(3 downto 0),
			Seg => iDigitOut2);
		
		U5: D4to7 port map (				--Scan for the forth four bits
			Q => iDataOut2(7 downto 4),
			Seg => iDigitOut3);
		
		U6: scan4digit port map (     --Map the value to output
			Digit3 => iDigitOut3,
			Digit2 => iDigitOut2,
			Digit1 => iDigitOut1,
			Digit0 => iDigitOut0,
			Clock => SystemClock,
			An => An,                  --Output for 7 segment display
			Ca => Ca,
			Cb => Cb,
			Cc => Cc,
			Cd => Cd,
			Ce => Ce,
			Cf => Cf,
			Cg => Cg);
end Behavioral;
