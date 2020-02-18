library ieee;
use ieee.std_logic_1164.all;

entity bistabilD is
	port (
	d, clock: in std_logic; 
	enable: in std_logic;
	q: out std_logic
	);
end bistabilD;


architecture arh_bistabilD of bistabilD  is
begin 
	process (clock)									
	begin
		if rising_edge(clock) and enable = '1' then
			q<=d;
		end if;
	end process;
end arh_bistabilD;	