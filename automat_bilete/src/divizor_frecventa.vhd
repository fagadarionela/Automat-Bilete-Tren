library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity divizor_de_frecventa is
	port(
	clock: in std_logic;
	clock_div: out std_logic
	);
end divizor_de_frecventa;

architecture arh_divizor_frecventa of divizor_de_frecventa is

begin 

	process(clock)
	variable var_div: std_logic_vector(26 downto 0) := "000000000000000000000000000";
	begin
		if clock'event and clock='0' then
			var_div := var_div + 1;
		end if;	
		clock_div <= var_div(12);
	end process;

end arh_divizor_frecventa;