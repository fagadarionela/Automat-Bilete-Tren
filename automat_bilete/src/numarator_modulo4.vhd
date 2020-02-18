library IEEE;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;  
use IEEE.numeric_std.all;

entity numarator_modulo4 is
	port(
	clock: in std_logic;
	Q: out std_logic_vector(3 downto 0)
	);
end entity;

architecture arh_numarator_modulo4 of numarator_modulo4 is

begin

	process(clock)
	variable v:std_logic_vector(3 downto 0):="1110";
	begin
		if clock'event and clock='1' then 
			case v is 
				when "1110" => v := "1101"; 
				when "1101" => v := "1011";
				when "1011" => v := "0111";
				when "0111" => v := "1110";
				when others => v := "1111";
			end case;
		end if;
		Q <= v;
	end process;
	
end arh_numarator_modulo4;