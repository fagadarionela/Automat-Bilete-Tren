library ieee;
use ieee.std_logic_1164.all;

entity mux4_1 is
	port(
	input1: in std_logic_vector(3 downto 0);
	input2: in std_logic_vector(3 downto 0);
	input3: in std_logic_vector(3 downto 0);
	input4: in std_logic_vector(3 downto 0);
	selectie: in std_logic_vector(1 downto 0);
	iesire: out std_logic_vector(3 downto 0)
	);
end mux4_1;

architecture arh_mux4_1 of mux4_1 is

begin
	process(input1, input2, input3, input4, selectie)
	begin
		if selectie(1)='0' and selectie(0)='0' then 
			iesire <= input1(3 downto 0);	
		elsif selectie(1)='0' and selectie(1)='0' then 
			iesire <= input2(3 downto 0);
		elsif  selectie(1)='1' and selectie(0)='0' then 	
			iesire <= input3(3 downto 0);
		else iesire <= input4(3 downto 0);
			end if;
	end process;
end arh_mux4_1;