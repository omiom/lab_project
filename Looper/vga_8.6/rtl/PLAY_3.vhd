library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_unsigned.all;
--use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity PLAY_3 is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		PLAY			: IN STD_LOGIC;
		
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end PLAY_3;

architecture behav of PLAY_3 is 

constant object_X_size : integer := 80;
constant object_Y_size : integer := 80;
--constant R_high		: integer := 7;
--constant R_low		: integer := 5;
--constant G_high		: integer := 4;
--constant G_low		: integer := 2;
--constant B_high		: integer := 1;
--constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := ( 
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"b6",x"6d",x"49",x"24",x"00",x"00",x"00",x"00",x"00",x"24",x"49",x"6d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"44",x"8d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"49",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"28",x"2d",x"4d",x"72",x"72",x"76",x"72",x"72",x"72",x"51",x"2d",x"08",x"04",x"00",x"00",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"29",x"51",x"76",x"9a",x"9a",x"bb",x"bb",x"bb",x"bb",x"bb",x"bf",x"bb",x"bb",x"9a",x"9a",x"76",x"4d",x"08",x"04",x"00",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"29",x"51",x"96",x"9a",x"9a",x"76",x"72",x"51",x"4d",x"2d",x"2d",x"4d",x"4d",x"76",x"76",x"9a",x"bb",x"bf",x"9a",x"76",x"51",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"08",x"51",x"96",x"9a",x"76",x"51",x"2d",x"04",x"04",x"04",x"00",x"00",x"04",x"04",x"04",x"04",x"04",x"08",x"4d",x"76",x"9a",x"9a",x"9a",x"76",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"00",x"04",x"2d",x"76",x"9a",x"76",x"4d",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"04",x"04",x"00",x"00",x"04",x"29",x"72",x"9a",x"9f",x"9a",x"71",x"28",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"4d",x"96",x"76",x"51",x"28",x"04",x"04",x"04",x"04",x"24",x"24",x"24",x"24",x"24",x"04",x"24",x"24",x"04",x"24",x"24",x"04",x"00",x"00",x"08",x"2d",x"76",x"9a",x"9a",x"76",x"2d",x"04",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"4d",x"96",x"76",x"2d",x"04",x"08",x"28",x"24",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"00",x"00",x"24",x"24",x"04",x"04",x"04",x"08",x"51",x"7a",x"7a",x"56",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"9a",x"72",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"71",x"76",x"76",x"7a",x"2d",x"04",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"2d",x"9a",x"51",x"08",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"51",x"7a",x"76",x"76",x"28",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"08",x"76",x"76",x"08",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"00",x"04",x"52",x"76",x"7a",x"51",x"08",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"76",x"29",x"04",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"04",x"08",x"76",x"76",x"76",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"29",x"76",x"51",x"04",x"28",x"04",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"24",x"24",x"04",x"04",x"2d",x"76",x"76",x"55",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"76",x"08",x"04",x"24",x"04",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"24",x"04",x"24",x"04",x"04",x"51",x"7a",x"76",x"2d",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"29",x"76",x"4d",x"04",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"00",x"04",x"00",x"24",x"04",x"08",x"76",x"7a",x"51",x"29",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"51",x"28",x"04",x"24",x"24",x"24",x"24",x"24",x"24",x"24",x"04",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"00",x"00",x"24",x"04",x"04",x"52",x"5a",x"56",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"92",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"08",x"76",x"4d",x"04",x"04",x"04",x"04",x"24",x"24",x"04",x"04",x"04",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"28",x"04",x"04",x"28",x"04",x"04",x"04",x"04",x"24",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"20",x"04",x"04",x"2d",x"76",x"76",x"51",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"08",x"76",x"2d",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"04",x"04",x"04",x"04",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"04",x"24",x"04",x"04",x"08",x"76",x"76",x"55",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2d",x"71",x"08",x"04",x"04",x"04",x"28",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"08",x"08",x"04",x"04",x"71",x"76",x"28",x"08",x"04",x"04",x"28",x"2c",x"28",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"51",x"76",x"55",x"0c",x"04",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"20",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"51",x"04",x"04",x"04",x"04",x"71",x"71",x"4d",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"28",x"04",x"51",x"bf",x"75",x"04",x"04",x"08",x"51",x"75",x"76",x"55",x"51",x"28",x"04",x"04",x"04",x"04",x"04",x"31",x"56",x"56",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"51",x"4d",x"04",x"04",x"04",x"04",x"76",x"96",x"96",x"76",x"51",x"2d",x"04",x"04",x"04",x"08",x"04",x"04",x"08",x"04",x"04",x"04",x"2d",x"bf",x"9a",x"08",x"08",x"04",x"55",x"9a",x"75",x"7a",x"7a",x"55",x"51",x"28",x"04",x"04",x"04",x"04",x"2d",x"56",x"56",x"31",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"51",x"2d",x"04",x"04",x"04",x"04",x"76",x"76",x"76",x"76",x"76",x"96",x"76",x"51",x"28",x"04",x"04",x"08",x"08",x"04",x"08",x"08",x"96",x"df",x"4d",x"08",x"08",x"2d",x"7a",x"75",x"55",x"55",x"75",x"55",x"76",x"51",x"04",x"04",x"04",x"04",x"0c",x"56",x"55",x"31",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"51",x"2d",x"04",x"04",x"04",x"04",x"72",x"76",x"7a",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"2d",x"28",x"04",x"04",x"08",x"71",x"df",x"96",x"04",x"08",x"04",x"55",x"9a",x"75",x"7a",x"55",x"55",x"55",x"55",x"51",x"08",x"04",x"04",x"04",x"08",x"56",x"35",x"31",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"51",x"2c",x"04",x"04",x"00",x"04",x"72",x"7a",x"56",x"76",x"76",x"7a",x"7a",x"7a",x"7a",x"76",x"51",x"08",x"04",x"04",x"28",x"df",x"bf",x"28",x"04",x"04",x"08",x"51",x"9a",x"7a",x"75",x"75",x"55",x"55",x"55",x"55",x"08",x"04",x"04",x"00",x"08",x"56",x"35",x"31",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"2d",x"04",x"04",x"24",x"00",x"51",x"7a",x"76",x"76",x"7a",x"9a",x"96",x"71",x"2d",x"08",x"04",x"04",x"04",x"04",x"96",x"df",x"2d",x"04",x"04",x"04",x"04",x"2d",x"7a",x"76",x"55",x"7a",x"55",x"55",x"55",x"51",x"04",x"04",x"04",x"04",x"0c",x"55",x"55",x"31",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"31",x"2d",x"04",x"04",x"00",x"04",x"76",x"7a",x"7a",x"76",x"76",x"4d",x"08",x"04",x"04",x"04",x"04",x"04",x"04",x"4d",x"ba",x"71",x"04",x"04",x"04",x"08",x"04",x"08",x"75",x"7a",x"7a",x"7a",x"79",x"76",x"76",x"2d",x"00",x"04",x"04",x"04",x"0c",x"55",x"55",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"44",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2d",x"2d",x"04",x"04",x"00",x"04",x"71",x"51",x"4d",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"28",x"9a",x"96",x"04",x"04",x"04",x"04",x"08",x"04",x"04",x"2c",x"71",x"76",x"75",x"76",x"51",x"2d",x"04",x"04",x"04",x"04",x"04",x"0d",x"55",x"55",x"0d",x"04",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"69",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"2c",x"2d",x"04",x"04",x"00",x"24",x"29",x"04",x"00",x"04",x"04",x"04",x"00",x"00",x"04",x"24",x"04",x"04",x"4d",x"76",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"28",x"2d",x"2d",x"4d",x"08",x"04",x"04",x"04",x"24",x"04",x"04",x"31",x"55",x"31",x"0c",x"04",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"b2",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"08",x"51",x"08",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"00",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"28",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"24",x"04",x"08",x"31",x"55",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"51",x"28",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"04",x"04",x"00",x"04",x"04",x"08",x"35",x"51",x"2d",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2d",x"4d",x"04",x"00",x"00",x"00",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"00",x"04",x"24",x"04",x"04",x"24",x"24",x"24",x"04",x"04",x"04",x"00",x"04",x"24",x"04",x"24",x"00",x"00",x"00",x"24",x"04",x"04",x"2d",x"35",x"31",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"08",x"4d",x"04",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"00",x"04",x"00",x"04",x"24",x"04",x"00",x"04",x"00",x"04",x"24",x"04",x"00",x"04",x"04",x"00",x"00",x"24",x"00",x"24",x"04",x"08",x"31",x"35",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2d",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"24",x"04",x"00",x"04",x"04",x"0c",x"55",x"30",x"2c",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"08",x"4d",x"08",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"00",x"00",x"04",x"04",x"04",x"08",x"31",x"55",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2c",x"4d",x"04",x"00",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"00",x"00",x"00",x"00",x"04",x"00",x"00",x"04",x"2c",x"31",x"31",x"2c",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"4d",x"4d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"00",x"04",x"2c",x"51",x"31",x"0c",x"08",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"4d",x"29",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"00",x"04",x"08",x"31",x"51",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"db",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"28",x"4d",x"28",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"2c",x"31",x"31",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"28",x"2d",x"28",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"2c",x"31",x"31",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"08",x"51",x"2d",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"2d",x"51",x"51",x"31",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"00",x"08",x"2d",x"51",x"2c",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"08",x"2d",x"31",x"31",x"2c",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"28",x"2d",x"4d",x"2d",x"08",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"08",x"2c",x"2d",x"31",x"31",x"31",x"2c",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"28",x"4d",x"4d",x"2d",x"28",x"28",x"08",x"04",x"04",x"04",x"04",x"04",x"08",x"08",x"2c",x"2d",x"51",x"31",x"2d",x"0c",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"28",x"2d",x"2d",x"2d",x"4d",x"51",x"51",x"51",x"51",x"51",x"51",x"51",x"51",x"2d",x"2c",x"08",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"08",x"08",x"28",x"2c",x"2c",x"2c",x"2c",x"08",x"08",x"08",x"08",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"49",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"49",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"00",x"00",x"00",x"00",x"04",x"24",x"29",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"00",x"24",x"24",x"24",x"45",x"49",x"25",x"04",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"20",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"49",x"00",x"00",x"00",x"25",x"49",x"25",x"25",x"49",x"49",x"49",x"49",x"29",x"25",x"24",x"24",x"24",x"24",x"24",x"20",x"24",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"49",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"00",x"00",x"00",x"49",x"49",x"25",x"49",x"49",x"49",x"49",x"49",x"49",x"49",x"49",x"29",x"25",x"24",x"24",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"24",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"24",x"24",x"24",x"49",x"49",x"49",x"49",x"49",x"49",x"49",x"25",x"24",x"24",x"24",x"24",x"24",x"20",x"00",x"00",x"00",x"00",x"00",x"49",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6e",x"49",x"24",x"24",x"24",x"24",x"25",x"25",x"24",x"24",x"24",x"04",x"00",x"24",x"00",x"00",x"00",x"24",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"b6",x"6d",x"49",x"24",x"00",x"00",x"00",x"00",x"00",x"24",x"49",x"6d",x"b6",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
(x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff")
);
-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
("00000000000000000000001111111111111100000000000000000000000000000000000000000000"),
("00000000000000000001111111111111111111110000000000000000000000000000000000000000"),
("00000000000000000111111111111111111111111100000000000000000000000000000000000000"),
("00000000000000011111111111111111111111111111000000000000000000000000000000000000"),
("00000000000000111111111111111111111111111111110000000000000000000000000000000000"),
("00000000000011111111111111111111111111111111111000000000000000000000000000000000"),
("00000000000111111111111111111111111111111111111100000000000000000000000000000000"),
("00000000001111111111111111111111111111111111111111000000000000000000000000000000"),
("00000000111111111111111111111111111111111111111111100000000000000000000000000000"),
("00000000111111111111111111111111111111111111111111100000000000000000000000000000"),
("00000001111111111111111111111111111111111111111111110000000000000000000000000000"),
("00000011111111111111111111111111111111111111111111111000000000000000000000000000"),
("00000111111111111111111111111111111111111111111111111100000000000000000000000000"),
("00000111111111111111111111111111111111111111111111111100000000000000000000000000"),
("00001111111111111111111111111111111111111111111111111110000000000000000000000000"),
("00011111111111111111111111111111111111111111111111111111000000000000000000000000"),
("00011111111111111111111111111111111111111111111111111111000000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("11111111111111111111111111111111111111111111111111111111111000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("01111111111111111111111111111111111111111111111111111111110000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("00111111111111111111111111111111111111111111111111111111100000000000000000000000"),
("00011111111111111111111111111111111111111111111111111111000000000000000000000000"),
("00011111111111111111111111111111111111111111111111111111000000000000000000000000"),
("00001111111111111111111111111111111111111111111111111110000000000000000000000000"),
("00000111111111111111111111111111111111111111111111111110000000000000000000000000"),
("00000111111111111111111111111111111111111111111111111100000000000000000000000000"),
("00000011111111111111111111111111111111111111111111111000000000000000000000000000"),
("00000001111111111111111111111111111111111111111111110000000000000000000000000000"),
("00000000111111111111111111111111111111111111111111100000000000000000000000000000"),
("00000000011111111111111111111111111111111111111111000000000000000000000000000000"),
("00000000011111111111111111111111111111111111111111000000000000000000000000000000"),
("00000000000111111111111111111111111111111111111100000000000000000000000000000000"),
("00000000000011111111111111111111111111111111111000000000000000000000000000000000"),
("00000000000001111111111111111111111111111111110000000000000000000000000000000000"),
("00000000000000011111111111111111111111111111000000000000000000000000000000000000"),
("00000000000000000111111111111111111111111100000000000000000000000000000000000000"),
("00000000000000000001111111111111111111110000000000000000000000000000000000000000"),
("00000000000000000000001111111111111110000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000"),
("00000000000000000000000000000000000000000000000000000000000000000000000000000000")


);


signal		ObjectStartX	:  integer:=346;
signal 		ObjectStartY 	:  integer:=312;
		
signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectEndX : integer;
signal objectEndY : integer;

begin

-- Calculate object end boundaries
objectEndX	<= object_X_size+ObjectStartX;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			 mVGA_RGB	<=  (others => '0') ; 	
			drawing_request	<=  '0' ;

			IF (PLAY = '1') THEN
			mVGA_RGB	<=  object_colors(bCoord_Y , bCoord_X);	--get from colors table 
			drawing_request	<= object(bCoord_Y , bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle
			END IF;
	end if;

  end process;

		
end behav;		
		