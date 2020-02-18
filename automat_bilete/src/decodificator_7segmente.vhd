library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
	  
entity decodificator_pe_7_segmente is 
	port(
	intrari: in std_logic_vector(3 downto 0);
	catod: out std_logic_vector(0 to 7)
	);	
		
end entity;
	  
architecture arh_decodificator_pe_7_segemente of decodificator_pe_7_segmente is

begin

    
		  
	with intrari select catod(0 to 7) <= "00000011" when "0000",
									     "10011111" when "0001",
									     "00100101" when "0010",
									     "00001101" when "0011",
									     "10011001" when "0100",
									     "01001001" when "0101",
									     "01000001" when "0110",
									     "00011111" when "0111",
									     "00000001" when "1000", 
									     "00001001" when "1001",
									     "11111101" when others;
						                                     
end arh_decodificator_pe_7_segemente;