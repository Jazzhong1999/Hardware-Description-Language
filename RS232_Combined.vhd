library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RS232 is   --Main component, combined with Txd and Rxd
    port (
        Reset, Clock16x, Rxd, Send  : in std_logic;
        DataOut1         			   : out std_logic_vector (7 downto 0);
        DataIn1                     : in std_logic_vector(7 downto 0);
        Txd                         : out std_logic
    );
end RS232;

architecture Behavioral of RS232 is
    component Rs232Rxd                        --Define RXD component here
        port (
            Reset, Clock16x, Rxd : in std_logic;
            DataOut1 : out std_logic_vector (7 downto 0));
    end component;
	 
    component RS232Txd								 --Define TXD component here
        port (
            Reset, Send, Clock16x : in std_logic;
            DataIn1                : in std_logic_vector(7 downto 0);
            Txd                   : out std_logic);
    end component;
	 
signal int_connect : STD_LOGIC; --declare a wire for internal connection
	 
begin
    U1 : Rs232Rxd port map(
        Reset    => Reset,
        Clock16x => Clock16x,
        Rxd => Rxd,  --Change back to Rxd while preseting top level
        DataOut1 => DataOut1);
		  
    U2 : Rs232Txd port map(
        Reset    => Reset,
        Send     => send,
        Clock16x => Clock16x,
        DataIn1   => DataIn1,  
        Txd      => Txd); --Change back to Txd while presenting top level

end Behavioral;
