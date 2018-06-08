Library ieee ;
use ieee.std_logic_1164.all ;
use ieee.STD_LOGIC_arith.all;
use ieee.STD_LOGIC_UNSIGNED.all;


entity KEY_recived_1 is

port ( resetN : in std_logic ;
 clk : in std_logic ;
 din : in std_logic_vector (8 downto 0);
 KEY_CODE: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 make : in std_logic ;
 break : in std_logic ;
 recived: in std_logic;
 dout : out std_logic ;
 channel :	out std_logic_vector(1 downto 0));
end KEY_recived_1;

architecture behavior of KEY_recived_1 is

 signal pressed: std_logic;
 signal out_X: std_logic;
 signal sig : std_logic_vector (1 downto 0);
begin

 dout <= out_X;
 channel<=sig;
 process ( resetN , clk)
	 begin
		 if resetN = '0' then
			 out_X <= '0';
			 pressed <= '0';
			 sig<="00";
		 elsif rising_edge(clk) then
			 if (din(7 DOWNTO 0) = KEY_CODE) and (make = '1') and (pressed ='0')  Then
			 pressed <= '1';
			 out_X <= '1';
			 sig<="00";
			 elsif (recived='1') then
			 pressed <= '0';
			 OUT_X<='0';
			 end if;
		 end if;
	 end process;
end architecture;