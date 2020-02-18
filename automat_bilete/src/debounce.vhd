library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
	port(
	clock: in std_logic;
	input: in std_logic;
	output: out std_logic);
end debounce;

architecture arh_debounce of debounce is

component bistabilD is
	port (
	d, clock: in std_logic;
	enable: in std_logic;
	q: out std_logic
	);
end component;


signal d1, d2, d3: std_logic;
signal numar: std_logic_vector(26 downto 0):=(others=>'0');
begin
    
	process	(clock, input)
	
    variable delay1, delay2, delay3: std_logic;
    
	
	begin
	
	if rising_edge(clock) then
	
		if numar(22)='1' then
		    numar <= (others=>'0');
		end if; 
		
		if (d1='0' and d2='1') or (d1='1' and d2='0') then
			numar <= (others=>'0');
		else
			numar <= std_logic_vector(unsigned(numar)+1);
		end if;
		
		
	    output <= d3;
	    
	end if;
	end process;
	
	bistabil1: bistabilD port map (input, clock, '1', d1);
	bistabil2: bistabilD port map (d1, clock, '1', d2);
	bistabil3: bistabilD port map (d2, clock, numar(22), d3);	
	
end arh_debounce;
	